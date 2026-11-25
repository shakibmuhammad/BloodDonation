(function () {
  'use strict';

  var menuButton = document.querySelector('.menu-toggle');
  var menu = document.querySelector('#main-menu');
  if (menuButton && menu) {
    menuButton.addEventListener('click', function () {
      var expanded = menuButton.getAttribute('aria-expanded') === 'true';
      menuButton.setAttribute('aria-expanded', String(!expanded));
      menu.classList.toggle('is-open', !expanded);
    });
  }

  var ctx = (document.body && document.body.dataset.contextPath) || '';
  document.querySelectorAll('select[data-district-source]').forEach(function (upazilaSelect) {
    var district = document.getElementById(upazilaSelect.dataset.districtSource);
    if (!district) return;
    var selected = upazilaSelect.dataset.selected || upazilaSelect.value || '';
    var requestNumber = 0;
    function loadUpazilas() {
      var restoreSelection = arguments.length > 0 && arguments[0] === true;
      var currentRequest = ++requestNumber;
      if (!restoreSelection) selected = '';
      var districtId = district.value;
      upazilaSelect.innerHTML = '';
      var placeholder = document.createElement('option');
      placeholder.value = '';
      placeholder.textContent = districtId ? (upazilaSelect.dataset.upazilaLoading || '') : (upazilaSelect.dataset.upazilaChoose || '');
      upazilaSelect.appendChild(placeholder);
      upazilaSelect.disabled = !districtId;
      if (!districtId) return;
      upazilaSelect.disabled = true;
      fetch(ctx + '/upazilas?districtId=' + encodeURIComponent(districtId), { credentials: 'same-origin' })
        .then(function (response) { if (!response.ok) throw new Error('Upazila list unavailable'); return response.json(); })
        .then(function (upazilas) {
          if (currentRequest !== requestNumber) return;
          if (!Array.isArray(upazilas)) throw new Error('Invalid upazila list');
          placeholder.textContent = upazilas.length ? (upazilaSelect.dataset.upazilaAny || '') : (upazilaSelect.dataset.upazilaNone || '');
          upazilas.forEach(function (upazila) {
            var option = document.createElement('option');
            option.value = upazila.id;
            option.textContent = upazila.name;
            if (String(upazila.id) === String(selected)) option.selected = true;
            upazilaSelect.appendChild(option);
          });
          if (selected && !Array.prototype.some.call(upazilaSelect.options, function (option) { return String(option.value) === String(selected); })) selected = '';
          upazilaSelect.disabled = false;
        })
        .catch(function () {
          if (currentRequest !== requestNumber) return;
          placeholder.textContent = upazilaSelect.dataset.upazilaError || '';
          upazilaSelect.disabled = false;
        });
    }
    district.addEventListener('change', function () { loadUpazilas(false); });
    district.addEventListener('district:restore', function () { loadUpazilas(true); });
    loadUpazilas(true);
  });

  document.querySelectorAll('input[type="tel"]').forEach(function (input) {
    input.addEventListener('input', function () {
      var normalized = input.value.replace(/[\s-]/g, '');
      var valid = /^(?:\+?880|0)1[3-9]\d{8}$/.test(normalized);
      input.setCustomValidity(input.value && !valid ? (input.dataset.phoneError || '') : '');
    });
    input.addEventListener('blur', function () { input.value = input.value.replace(/[\s-]/g, ''); });
  });

  document.querySelectorAll('form[data-confirm]').forEach(function (form) {
    form.addEventListener('submit', function (event) {
      if (!window.confirm(form.dataset.confirm)) event.preventDefault();
    });
  });
}());
