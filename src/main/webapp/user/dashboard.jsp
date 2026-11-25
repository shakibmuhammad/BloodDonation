<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/lang.jspf" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitleKey" scope="request" value="page.dashboard"/>
<jsp:include page="/includes/header.jsp"/>
<main id="main" class="page-main user-dashboard-page">
  <section class="user-dashboard-hero" aria-labelledby="user-dashboard-title">
    <div class="container user-dashboard-hero-inner"><div><p class="eyebrow"><fmt:message key="dashboard.eyebrow"/></p><h1 id="user-dashboard-title"><fmt:message key="dashboard.welcome"/> <c:out value="${donor.fullName}"/></h1><p><fmt:message key="dashboard.intro"/></p></div><a class="button button-light" href="${pageContext.request.contextPath}/user/profile"><fmt:message key="dashboard.manage"/></a></div>
  </section>
  <section class="container user-dashboard-content">
    <c:if test="${donor.status eq 'PENDING'}"><div class="alert alert-warm dashboard-status-banner"><strong><fmt:message key="dashboard.pendingTitle"/></strong> <fmt:message key="dashboard.pendingBody"/></div></c:if>
    <c:if test="${donor.status eq 'BLOCKED'}"><div class="alert alert-error dashboard-status-banner"><strong><fmt:message key="dashboard.blockedTitle"/></strong> <fmt:message key="dashboard.blockedBody"/></div></c:if>
    <div class="user-dashboard-grid">
      <section class="donor-overview-card" aria-labelledby="donor-overview-title">
        <div class="donor-overview-top"><span class="blood-badge blood-badge-large"><c:out value="${donor.bloodGroup}"/></span><span class="status-pill donor-status-${fn:toLowerCase(donor.status)}"><fmt:message key="status.${fn:toLowerCase(donor.status)}"/></span></div>
        <h2 id="donor-overview-title"><c:out value="${donor.fullName}"/></h2><p class="donor-overview-email"><c:out value="${donor.email}"/></p>
        <p class="location-line"><c:if test="${not empty donor.upazilaName}"><c:out value="${donor.upazilaName}"/>, </c:if><c:out value="${donor.districtName}"/></p>
        <div class="donor-availability"><span><fmt:message key="dashboard.searchAvailability"/></span><strong class="${donor.available eq 'Y' ? 'is-available' : 'is-paused'}"><i aria-hidden="true"></i><fmt:message key="${donor.available eq 'Y' ? 'status.available' : 'status.paused'}"/></strong></div>
        <a class="button button-block" href="${pageContext.request.contextPath}/user/profile"><fmt:message key="dashboard.manage"/></a>
      </section>
      <div class="user-dashboard-actions">
        <article class="dashboard-action-card"><span class="dashboard-action-icon" aria-hidden="true">♡</span><div><h2><fmt:message key="dashboard.availabilityTitle"/></h2><p><fmt:message key="dashboard.availabilityBody"/></p><a class="text-link" href="${pageContext.request.contextPath}/user/profile"><fmt:message key="dashboard.updateAvailability"/> <span aria-hidden="true">→</span></a></div></article>
        <article class="dashboard-action-card"><span class="dashboard-action-icon" aria-hidden="true">✳</span><div><h2><fmt:message key="dashboard.donatedTitle"/></h2><p><fmt:message key="dashboard.donatedBody"/></p><a class="text-link" href="${pageContext.request.contextPath}/user/profile"><fmt:message key="dashboard.updateDonation"/> <span aria-hidden="true">→</span></a></div></article>
        <article class="dashboard-action-card"><span class="dashboard-action-icon" aria-hidden="true">⌕</span><div><h2><fmt:message key="dashboard.helpTitle"/></h2><p><fmt:message key="dashboard.helpBody"/></p><a class="text-link" href="${pageContext.request.contextPath}/requests"><fmt:message key="dashboard.browseRequests"/> <span aria-hidden="true">→</span></a></div></article>
      </div>
    </div>
  </section>
</main>
<jsp:include page="/includes/footer.jsp"/>
