<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
include file="/WEB-INF/jspf/lang.jspf" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitleKey" scope="request" value="page.requestForm" />
<jsp:include page="/includes/header.jsp" />
<main id="main" class="page-main">
  <section class="form-page container">
    <div class="form-intro">
      <p class="eyebrow">
        <fmt:message key="request.eyebrow" />
      </p>
      <h1>
        <fmt:message key="request.heading" />
      </h1>
      <p>
        <fmt:message key="request.intro" />
      </p>
      <div class="note-card">
        <span class="note-icon">✳</span>
        <div>
          <strong>
            <fmt:message key="request.urgentHeading" />
          </strong>
          <p>
            <fmt:message key="request.urgentBody" />
          </p>
        </div>
      </div>
    </div>
    <div class="panel form-panel">
      <c:if test="${not empty error}">
        <p class="alert alert-error">
          <c:out value="${error}" />
        </p>
      </c:if>
      <form
        method="post"
        action="${pageContext.request.contextPath}/request"
        class="form-grid"
        data-validate
      >
        <input
          type="hidden"
          name="csrfToken"
          value="<c:out value='${csrfToken}'/>"
        /><label>
          <fmt:message key="request.patient" /><input
            name="patientName"
            maxlength="120"
            required
          /> </label
        ><label>
          <fmt:message key="common.bloodGroup" /><select
            name="bloodGroup"
            required
            data-searchable
            data-search-placeholder="${msgSearchPlaceholder}"
            data-search-no-results="${msgSearchNoResults}"
            data-search-required="${msgSearchRequired}"
          >
            <option value="">
              <fmt:message key="common.chooseGroup" />
            </option>
            <option>A+</option>
            <option>A-</option>
            <option>B+</option>
            <option>B-</option>
            <option>AB+</option>
            <option>AB-</option>
            <option>O+</option>
            <option>O-</option>
          </select> </label
        ><label class="full-field">
          <fmt:message key="request.hospital" /><input
            name="hospital"
            maxlength="180"
            required
          />
        </label>
        <c:set var="divisionSelectId" value="requestDivision" />
        <c:set var="divisionTargetId" value="districtId" />
        <%@ include file="/WEB-INF/jspf/division-select.jspf" %><label>
          <fmt:message key="common.district" /><select
            name="districtId"
            id="districtId"
            required
            data-searchable
            data-search-placeholder="${msgSearchPlaceholder}"
            data-search-no-results="${msgSearchNoResults}"
            data-search-required="${msgSearchRequired}"
          >
            <option value="">
              <fmt:message key="common.chooseDistrict" />
            </option>
            <c:forEach var="d" items="${districts}">
              <option value="${d.districtId}" data-division="${d.division}">
                <c:out value="${d.name}" />
              </option>
            </c:forEach>
          </select> </label
        ><label>
          <fmt:message key="common.upazila" />
          <span class="optional">
            <fmt:message key="common.optional" /> </span
          ><select
            name="upazilaId"
            id="upazilaSelect"
            data-district-source="districtId"
            disabled
            data-searchable
            data-search-placeholder="${msgSearchPlaceholder}"
            data-search-no-results="${msgSearchNoResults}"
            data-search-required="${msgSearchRequired}"
            data-upazila-any="${msgAnyUpazila}"
            data-upazila-choose="${msgChooseDistrictFirst}"
            data-upazila-error="${msgUpazilaLoadError}"
            data-upazila-loading="${msgUpazilaLoading}"
            data-upazila-none="${msgNoUpazilas}"
          >
            <option value="">
              <fmt:message key="select.chooseDistrictFirst" />
            </option>
          </select> </label
        ><label>
          <fmt:message key="request.contactPhone" /><input
            name="contactPhone"
            type="tel"
            placeholder="${msgPhonePlaceholder}"
            required
            data-phone-error="${msgPhoneValidation}"
          /> </label
        ><label>
          <fmt:message key="request.date" /><input
            name="neededDate"
            type="date"
            min="<%= java.time.LocalDate.now() %>"
            required
          /> </label
        ><label class="full-field">
          <fmt:message key="request.details" />
          <span class="optional">
            <fmt:message key="common.optional" /> </span
          ><textarea
            name="details"
            rows="4"
            maxlength="1000"
            placeholder="${msgRequestDetailsPlaceholder}"
          ></textarea>
        </label>
        <div class="full-field">
          <button class="button button-block" type="submit">
            <fmt:message key="request.submit" />
          </button>
          <p class="form-note">
            <fmt:message key="request.contactNote" />
          </p>
        </div>
      </form>
    </div>
  </section>
</main>
<jsp:include page="/includes/footer.jsp" />
