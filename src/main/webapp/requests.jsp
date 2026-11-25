<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/lang.jspf" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitleKey" scope="request" value="page.requests"/>
<jsp:include page="/includes/header.jsp"/>

<main id="main" class="page-main">
  <section class="page-hero">
    <div class="container">
      <p class="eyebrow"><fmt:message key="requests.eyebrow"/></p>
      <h1><fmt:message key="requests.heading"/></h1>
      <p><fmt:message key="requests.intro"/></p>
    </div>
  </section>

  <section class="container page-content">
    <c:if test="${param.posted eq '1'}">
      <p class="alert alert-success"><fmt:message key="requests.posted"/></p>
    </c:if>

    <div class="search-card request-filter-card" aria-labelledby="request-filter-title"
         style="max-width:none;margin:0;padding:26px 28px;border:1px solid #eef0f2;border-radius:20px;background:#fff;box-shadow:0 16px 42px rgba(36,19,21,.10)">
      <div class="card-heading">
        <span class="icon-circle" aria-hidden="true" style="width:44px;height:44px">
          <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="10.8" cy="10.8" r="6.8"/><path d="m16 16 5 5M8 10.8h5.6M10.8 8v5.6"/>
          </svg>
        </span>
        <div>
          <p class="eyebrow"><fmt:message key="requests.eyebrow"/></p>
          <h2 id="request-filter-title"><fmt:message key="requests.filter"/></h2>
        </div>
      </div>

      <form class="filter-bar request-filter-form" action="${pageContext.request.contextPath}/requests" method="get"
            style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(100%,240px),1fr));align-items:end;gap:15px;padding:0;border:0;border-radius:0;background:transparent">
        <label style="min-width:0">
          <fmt:message key="common.bloodGroup"/>
          <select name="bloodGroup" data-searchable data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}" data-search-required="${msgSearchRequired}">
            <option value=""><fmt:message key="common.anyGroup"/></option>
            <option value="A+" ${bloodGroup eq 'A+' ? 'selected' : ''}>A+</option>
            <option value="A-" ${bloodGroup eq 'A-' ? 'selected' : ''}>A-</option>
            <option value="B+" ${bloodGroup eq 'B+' ? 'selected' : ''}>B+</option>
            <option value="B-" ${bloodGroup eq 'B-' ? 'selected' : ''}>B-</option>
            <option value="AB+" ${bloodGroup eq 'AB+' ? 'selected' : ''}>AB+</option>
            <option value="AB-" ${bloodGroup eq 'AB-' ? 'selected' : ''}>AB-</option>
            <option value="O+" ${bloodGroup eq 'O+' ? 'selected' : ''}>O+</option>
            <option value="O-" ${bloodGroup eq 'O-' ? 'selected' : ''}>O-</option>
          </select>
        </label>

        <c:set var="divisionSelectId" value="requestFilterDivision"/>
        <c:set var="divisionTargetId" value="requestFilterDistrict"/>
        <%@ include file="/WEB-INF/jspf/division-select.jspf" %>

        <label style="min-width:0">
          <fmt:message key="common.district"/>
          <select name="districtId" id="requestFilterDistrict" data-searchable data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}" data-search-required="${msgSearchRequired}">
            <option value=""><fmt:message key="common.allDistricts"/></option>
            <c:forEach var="d" items="${districts}">
              <option value="${d.districtId}" data-division="${d.division}" ${selectedDistrict eq d.districtId ? 'selected' : ''}><c:out value="${d.name}"/></option>
            </c:forEach>
          </select>
        </label>

        <label style="min-width:0">
          <fmt:message key="common.upazila"/>
          <select name="upazilaId" id="requestFilterUpazila" data-district-source="requestFilterDistrict" data-selected="${selectedUpazila}"
                  data-searchable data-search-placeholder="${msgSearchPlaceholder}" data-search-no-results="${msgSearchNoResults}"
                  data-upazila-any="${msgAnyUpazila}" data-upazila-choose="${msgChooseDistrictFirst}" data-upazila-error="${msgUpazilaLoadError}"
                  data-upazila-loading="${msgUpazilaLoading}" data-upazila-none="${msgNoUpazilas}" disabled>
            <option value=""><fmt:message key="select.chooseDistrictFirst"/></option>
          </select>
        </label>

        <div class="request-filter-actions" style="grid-column:1/-1;display:flex;align-items:center;gap:12px;flex-wrap:wrap">
          <button class="button" type="submit"><fmt:message key="requests.search"/></button>
          <a class="text-link" href="${pageContext.request.contextPath}/requests"><fmt:message key="requests.clearFilters"/></a>
          <a class="button button-outline" href="${pageContext.request.contextPath}/request"><fmt:message key="requests.postButton"/></a>
        </div>
      </form>
    </div>

    <div class="results-heading">
      <h2><c:out value="${totalResults}" default="0"/> <fmt:message key="adminHome.openRequests"/></h2>
      <span><fmt:message key="common.page"/> <c:out value="${page}"/></span>
    </div>

    <div class="request-grid request-grid-large">
      <c:forEach var="r" items="${requests}">
        <article class="request-card">
          <div class="request-top">
            <span class="blood-badge"><c:out value="${r.bloodGroup}"/></span>
            <span class="status-pill"><fmt:message key="common.open"/></span>
          </div>
          <h3><c:out value="${r.patientName}"/></h3>
          <p class="muted"><c:out value="${r.hospital}"/></p>
          <p class="location-line">
            <c:if test="${not empty r.upazilaName}"><c:out value="${r.upazilaName}"/>, </c:if>
            <c:out value="${r.districtName}"/>
          </p>
          <c:if test="${not empty r.details}"><p class="request-details"><c:out value="${r.details}"/></p></c:if>
          <div class="request-bottom">
            <span><fmt:message key="requests.needed"/> <strong><c:out value="${r.neededDate}"/></strong></span>
            <a class="phone-link" href="tel:<c:out value='${r.contactPhone}'/>"><fmt:message key="requests.call"/> <c:out value="${r.contactPhone}"/></a>
          </div>
        </article>
      </c:forEach>
      <c:if test="${empty requests}">
        <div class="empty-state empty-wide">
          <h3><fmt:message key="requests.emptyHeading"/></h3>
          <p><fmt:message key="requests.emptyBody"/></p>
        </div>
      </c:if>
    </div>

    <nav class="pagination" aria-label="${msgRequestsHeading}">
      <c:if test="${page gt 1}">
        <c:url var="previousPageUrl" value="/requests">
          <c:param name="bloodGroup" value="${bloodGroup}"/>
          <c:param name="districtId" value="${selectedDistrict}"/>
          <c:param name="upazilaId" value="${selectedUpazila}"/>
          <c:param name="page" value="${page - 1}"/>
        </c:url>
        <a href="${previousPageUrl}"><fmt:message key="common.previous"/></a>
      </c:if>
      <c:if test="${page * 10 lt totalResults}">
        <c:url var="nextPageUrl" value="/requests">
          <c:param name="bloodGroup" value="${bloodGroup}"/>
          <c:param name="districtId" value="${selectedDistrict}"/>
          <c:param name="upazilaId" value="${selectedUpazila}"/>
          <c:param name="page" value="${page + 1}"/>
        </c:url>
        <a href="${nextPageUrl}"><fmt:message key="common.next"/></a>
      </c:if>
    </nav>
  </section>
</main>
<jsp:include page="/includes/footer.jsp"/>


