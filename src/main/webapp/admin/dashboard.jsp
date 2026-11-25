<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
include file="/WEB-INF/jspf/lang.jspf" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitleKey" scope="request" value="page.adminDashboard" />
<jsp:include page="/admin/includes/header.jsp" />

<section class="admin-dashboard" aria-labelledby="admin-dashboard-title">
  <header class="admin-dashboard-welcome">
    <div>
      <p class="eyebrow">
        <fmt:message key="admin.overview" />
      </p>
      <h1 id="admin-dashboard-title">
        <fmt:message key="adminHome.greeting" />
        <c:out value="${sessionScope.adminName}" />
      </h1>
      <p>
        <fmt:message key="adminHome.snapshot" />
      </p>
    </div>
    <span class="date-chip"> <%= java.time.LocalDate.now() %> </span>
  </header>

  <div class="admin-dashboard-stats">
    <article class="admin-dashboard-stat">
      <span class="admin-stat-icon" aria-hidden="true">♡</span>
      <p>
        <fmt:message key="adminHome.registered" />
      </p>
      <strong>
        <c:out value="${donorCount}" default="0" /> </strong
      ><small>
        <c:out value="${activeDonorCount}" default="0" />
        <fmt:message key="common.activeProfiles" /> ·
        <c:out value="${availableDonorCount}" default="0" />
        <fmt:message key="adminHome.availableDonors" />
      </small>
    </article>
    <article class="admin-dashboard-stat is-pending">
      <span class="admin-stat-icon" aria-hidden="true">◷</span>
      <p>
        <fmt:message key="adminHome.awaiting" />
      </p>
      <strong>
        <c:out value="${pendingDonorCount}" default="0" /> </strong
      ><small>
        <c:out value="${blockedDonorCount}" default="0" />
        <fmt:message key="common.blocked" /> </small
      ><a href="${pageContext.request.contextPath}/admin/donors?status=PENDING">
        <fmt:message key="adminHome.reviewDonors" />
        <span aria-hidden="true">→</span>
      </a>
    </article>
    <article class="admin-dashboard-stat is-requests">
      <span class="admin-stat-icon" aria-hidden="true">✳</span>
      <p>
        <fmt:message key="adminHome.openRequests" />
      </p>
      <strong>
        <c:out value="${openRequestCount}" default="0" /> </strong
      ><small>
        <c:out value="${fulfilledRequestCount}" default="0" />
        <fmt:message key="adminHome.fulfilledRequests" /> ·
        <c:out value="${closedRequestCount}" default="0" />
        <fmt:message key="common.closed" /> ·
        <c:out value="${requestCount}" default="0" />
        <fmt:message key="common.records" />
      </small>
    </article>
    <article class="admin-dashboard-stat">
      <span class="admin-stat-icon" aria-hidden="true">⌖</span>
      <p>
        <fmt:message key="adminHome.districtsCovered" />
      </p>
      <strong>
        <c:out value="${districtCount}" default="0" /> </strong
      ><small>
        <c:out value="${divisionCount}" default="0" />
        <fmt:message key="adminHome.divisions" /> ·
        <c:out value="${upazilaCount}" default="0" />
        <fmt:message key="adminHome.upazilas" />
      </small>
    </article>
  </div>

  <div class="admin-dashboard-lower">
    <section
      class="admin-panel admin-quick-panel"
      aria-labelledby="admin-quick-title"
    >
      <div class="admin-panel-heading">
        <div>
          <p class="eyebrow">
            <fmt:message key="adminHome.quickActions" />
          </p>
          <h2 id="admin-quick-title">
            <fmt:message key="adminHome.keepMoving" />
          </h2>
        </div>
      </div>
      <div class="admin-quick-links">
        <a href="${pageContext.request.contextPath}/admin/donors?status=PENDING"
          ><span class="quick-link-number">01</span
          ><span
            ><strong>
              <fmt:message key="adminHome.reviewNew" /> </strong
            ><small>
              <fmt:message key="adminHome.reviewNewBody" /> </small></span
          ><b aria-hidden="true">→</b></a
        >
        <a href="${pageContext.request.contextPath}/admin/requests"
          ><span class="quick-link-number">02</span
          ><span
            ><strong>
              <fmt:message key="adminHome.updateRequests" /> </strong
            ><small>
              <fmt:message key="adminHome.updateRequestsBody" /> </small></span
          ><b aria-hidden="true">→</b></a
        >
        <a href="${pageContext.request.contextPath}/admin/locations"
          ><span class="quick-link-number">03</span
          ><span
            ><strong>
              <fmt:message key="adminHome.manageLocations" /> </strong
            ><small>
              <fmt:message key="adminHome.manageLocationsBody" /> </small></span
          ><b aria-hidden="true">→</b></a
        >
      </div>
    </section>
    <aside class="admin-dashboard-note">
      <span class="welcome-mark" aria-hidden="true">✦</span>
      <p class="eyebrow">
        <fmt:message key="adminHome.adminNote" />
      </p>
      <h2>
        <fmt:message key="adminHome.goodInfo" />
      </h2>
      <p>
        <fmt:message key="adminHome.accurateBody" />
      </p>
      <a href="${pageContext.request.contextPath}/admin/requests">
        <fmt:message key="adminHome.allRequestActivity" />
        <span aria-hidden="true">→</span>
      </a>
    </aside>
  </div>

  <div class="admin-dashboard-recent">
    <section
      class="admin-panel table-panel"
      aria-labelledby="admin-recent-donors"
    >
      <div class="admin-panel-heading admin-recent-heading">
        <div>
          <p class="eyebrow">
            <fmt:message key="adminHome.latestDonorsLabel" />
          </p>
          <h2 id="admin-recent-donors">
            <fmt:message key="adminHome.latestDonors" />
          </h2>
        </div>
        <a
          class="table-action"
          href="${pageContext.request.contextPath}/admin/donors"
        >
          <fmt:message key="adminHome.viewDonors" />
        </a>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>
                <fmt:message key="adminDonors.tableDonor" />
              </th>
              <th>
                <fmt:message key="common.bloodGroup" />
              </th>
              <th>
                <fmt:message key="common.location" />
              </th>
              <th>
                <fmt:message key="common.status" />
              </th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="d" items="${latestDonors}">
              <tr>
                <td>
                  <strong>
                    <c:out value="${d.fullName}" /> </strong
                  ><small>
                    <c:out value="${d.email}" />
                  </small>
                </td>
                <td>
                  <span class="blood-badge">
                    <c:out value="${d.bloodGroup}" />
                  </span>
                </td>
                <td>
                  <c:out value="${d.districtName}" />
                </td>
                <td>
                  <span class="table-status status-${fn:toLowerCase(d.status)}">
                    <fmt:message key="status.${fn:toLowerCase(d.status)}" />
                  </span>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty latestDonors}">
              <tr>
                <td colspan="4" class="table-empty">
                  <fmt:message key="adminHome.noRecentDonors" />
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </section>
    <section
      class="admin-panel table-panel"
      aria-labelledby="admin-recent-requests"
    >
      <div class="admin-panel-heading admin-recent-heading">
        <div>
          <p class="eyebrow">
            <fmt:message key="adminHome.latestRequestsLabel" />
          </p>
          <h2 id="admin-recent-requests">
            <fmt:message key="adminHome.latestRequests" />
          </h2>
        </div>
        <a
          class="table-action"
          href="${pageContext.request.contextPath}/admin/requests"
        >
          <fmt:message key="adminHome.viewRequests" />
        </a>
      </div>
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>
                <fmt:message key="adminRequests.tablePatient" />
              </th>
              <th>
                <fmt:message key="common.bloodGroup" />
              </th>
              <th>
                <fmt:message key="common.location" />
              </th>
              <th>
                <fmt:message key="common.status" />
              </th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="r" items="${latestRequests}">
              <tr>
                <td>
                  <strong>
                    <c:out value="${r.patientName}" /> </strong
                  ><small>
                    <c:out value="${r.hospital}" />
                  </small>
                </td>
                <td>
                  <span class="blood-badge">
                    <c:out value="${r.bloodGroup}" />
                  </span>
                </td>
                <td>
                  <c:out value="${r.districtName}" />
                </td>
                <td>
                  <span class="table-status status-${fn:toLowerCase(r.status)}">
                    <fmt:message key="status.${fn:toLowerCase(r.status)}" />
                  </span>
                </td>
              </tr>
            </c:forEach>
            <c:if test="${empty latestRequests}">
              <tr>
                <td colspan="4" class="table-empty">
                  <fmt:message key="adminHome.noRecentRequests" />
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>
    </section>
  </div>
</section>
<jsp:include page="/admin/includes/footer.jsp" />
