(function () {
  'use strict';

  var sequence = 0;

  function normalize(value) {
    return String(value || '').toLocaleLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim();
  }

  function enhance(select) {
    if (select.dataset.searchableReady === 'true') return null;
    select.dataset.searchableReady = 'true';
    var wasRequired = select.required;
    var wrapper = document.createElement('div');
    wrapper.className = 'searchable-select';
    select.parentNode.insertBefore(wrapper, select);
    wrapper.appendChild(select);
    select.classList.add('searchable-select__native');
    select.tabIndex = -1;
    select.setAttribute('aria-hidden', 'true');
    select.required = false;

    var input = document.createElement('input');
    input.type = 'text';
    input.className = 'searchable-select__input';
    input.autocomplete = 'off';
    input.spellcheck = false;
    input.placeholder = select.dataset.searchPlaceholder || '';
    input.setAttribute('role', 'combobox');
    input.setAttribute('aria-autocomplete', 'list');
    input.setAttribute('aria-expanded', 'false');
    input.setAttribute('aria-haspopup', 'listbox');
    input.required = wasRequired;
    input.disabled = select.disabled;
    var list = document.createElement('ul');
    list.className = 'searchable-select__list';
    list.id = 'searchable-select-list-' + (++sequence);
    list.setAttribute('role', 'listbox');
    list.hidden = true;
    input.setAttribute('aria-controls', list.id);
    wrapper.appendChild(input);
    wrapper.appendChild(list);

    var optionNodes = [];
    var listOpen = false;

    function selectedOption() {
      return select.options[select.selectedIndex] || null;
    }

    function syncFromSelect() {
      var option = selectedOption();
      if (document.activeElement !== input || !listOpen) input.value = option && option.value ? option.textContent : '';
      input.disabled = select.disabled;
      input.required = wasRequired && !select.disabled;
      input.setCustomValidity('');
    }

    function closeList(restoreSelection) {
      listOpen = false;
      input.setAttribute('aria-expanded', 'false');
      input.removeAttribute('aria-activedescendant');
      list.hidden = true;
      if (restoreSelection) syncFromSelect();
    }

    function selectOption(option) {
      if (!option || option.disabled) return;
      select.value = option.value;
      input.value = option.value ? option.textContent : '';
      input.setCustomValidity('');
      select.dispatchEvent(new Event('change', { bubbles: true }));
      closeList(false);
    }

    function setActive(step) {
      var enabled = optionNodes.filter(function (node) { return node.getAttribute('aria-disabled') !== 'true'; });
      if (!enabled.length) return;
      var current = enabled.indexOf(list.querySelector('.is-active'));
      var next = current < 0 ? (step > 0 ? 0 : enabled.length - 1) : (current + step + enabled.length) % enabled.length;
      var target = enabled[next];
      optionNodes.forEach(function (node) { node.classList.remove('is-active'); });
      target.classList.add('is-active');
      input.setAttribute('aria-activedescendant', target.id);
      target.scrollIntoView({ block: 'nearest' });
    }

    function renderList() {
      var query = normalize(input.value);
      var options = Array.prototype.slice.call(select.options);
      list.textContent = '';
      optionNodes = [];
      options.forEach(function (option, optionIndex) {
        var text = option.textContent.trim();
        if (query && normalize(text).indexOf(query) === -1) return;
        var item = document.createElement('li');
        item.className = 'searchable-select__option';
        item.id = list.id + '-option-' + optionIndex;
        item.setAttribute('role', 'option');
        item.setAttribute('aria-selected', String(option.value === select.value && option.value !== ''));
        item.setAttribute('aria-disabled', String(option.disabled));
        item.textContent = text;
        item.addEventListener('mousedown', function (event) { event.preventDefault(); });
        item.addEventListener('click', function () { selectOption(option); input.focus(); });
        list.appendChild(item);
        optionNodes.push(item);
      });
      if (!optionNodes.length) {
        var empty = document.createElement('li');
        empty.className = 'searchable-select__empty';
        empty.setAttribute('role', 'status');
        empty.textContent = select.dataset.searchNoResults || '';
        list.appendChild(empty);
      }
    }

    function openList() {
      if (input.disabled) return;
      renderList();
      listOpen = true;
      list.hidden = false;
      input.setAttribute('aria-expanded', 'true');
    }

    input.addEventListener('focus', openList);
    input.addEventListener('click', openList);
    input.addEventListener('input', function () {
      input.setCustomValidity('');
      var exact = Array.prototype.find.call(select.options, function (option) {
        return !option.disabled && normalize(option.textContent) === normalize(input.value);
      });
      if (exact) select.value = exact.value;
      else select.value = '';
      select.dispatchEvent(new Event('change', { bubbles: true }));
      renderList();
      listOpen = true;
      list.hidden = false;
      input.setAttribute('aria-expanded', 'true');
      if (wasRequired && !select.value) input.setCustomValidity(select.dataset.searchRequired || '');
    });
    input.addEventListener('keydown', function (event) {
      if (event.key === 'ArrowDown') {
        event.preventDefault();
        if (!listOpen) openList();
        setActive(1);
      } else if (event.key === 'ArrowUp') {
        event.preventDefault();
        if (!listOpen) openList();
        setActive(-1);
      } else if (event.key === 'Enter' && listOpen) {
        var active = list.querySelector('.is-active');
        if (active) {
          event.preventDefault();
          var index = parseInt(active.id.substring((list.id + '-option-').length), 10);
          selectOption(select.options[index]);
        }
      } else if (event.key === 'Escape') {
        closeList(true);
      } else if (event.key === 'Tab') {
        closeList(true);
      }
    });
    input.addEventListener('blur', function () {
      window.setTimeout(function () { closeList(true); }, 100);
    });
    select.addEventListener('change', syncFromSelect);

    var observer = new MutationObserver(function () {
      input.disabled = select.disabled;
      input.required = wasRequired && !select.disabled;
      if (listOpen) renderList();
      else syncFromSelect();
    });
    observer.observe(select, { childList: true, subtree: true, attributes: true, attributeFilter: ['disabled', 'selected'] });
    syncFromSelect();
    return { select: select, input: input, refresh: renderList };
  }

  function wireDivisionFilters() {
    document.querySelectorAll('select[data-division-filter]').forEach(function (divisionSelect) {
      var districtSelect = document.getElementById(divisionSelect.dataset.divisionFilter);
      if (!districtSelect) return;
      var sourceOptions = Array.prototype.map.call(districtSelect.options, function (option) { return option.cloneNode(true); });
      var firstPass = true;

      function setDivisionInput() {
        var wrapper = divisionSelect.closest('.searchable-select');
        var input = wrapper && wrapper.querySelector('.searchable-select__input');
        var option = divisionSelect.options[divisionSelect.selectedIndex];
        if (input) input.value = option && option.value ? option.textContent : '';
      }

      function filterDistricts(preserveDistrict) {
        var division = divisionSelect.value;
        var selectedDistrict = preserveDistrict ? districtSelect.value : '';
        districtSelect.textContent = '';
        sourceOptions.forEach(function (option, index) {
          var inDivision = !division || option.dataset.division === division;
          if (index === 0 || inDivision) districtSelect.appendChild(option.cloneNode(true));
        });
        var stillAvailable = Array.prototype.some.call(districtSelect.options, function (option) { return option.value === selectedDistrict; });
        districtSelect.value = stillAvailable ? selectedDistrict : '';
        var event = firstPass ? new CustomEvent('district:restore', { bubbles: true }) : new Event('change', { bubbles: true });
        firstPass = false;
        districtSelect.dispatchEvent(event);
      }

      divisionSelect.addEventListener('change', function (event) {
        filterDistricts(!!(event.detail && event.detail.preserveDistrict));
      });
      districtSelect.addEventListener('change', function () {
        if (!districtSelect.value) return;
        var chosenDistrict = districtSelect.options[districtSelect.selectedIndex];
        var division = chosenDistrict && chosenDistrict.dataset.division;
        if (division && divisionSelect.value !== division) {
          divisionSelect.value = division;
          setDivisionInput();
          divisionSelect.dispatchEvent(new CustomEvent('change', { bubbles: true, detail: { preserveDistrict: true } }));
        }
      });

      var selectedDistrict = districtSelect.options[districtSelect.selectedIndex];
      var initialDivision = selectedDistrict && selectedDistrict.dataset.division;
      if (districtSelect.value && initialDivision) {
        divisionSelect.value = initialDivision;
        setDivisionInput();
        divisionSelect.dispatchEvent(new CustomEvent('change', { bubbles: true, detail: { preserveDistrict: true } }));
      } else {
        filterDistricts(true);
      }
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('select[data-searchable]').forEach(enhance);
    wireDivisionFilters();
  });
}());
