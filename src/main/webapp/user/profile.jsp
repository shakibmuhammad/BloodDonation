<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@
include file="/WEB-INF/jspf/lang.jspf" %><%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %><c:set
  var="pageTitleKey"
  scope="request"
  value="page.profile"
/><jsp:include page="/includes/header.jsp" />
<main id="main" class="page-main">
  <section class="page-hero">
    <div class="container page-title-row">
      <div>
        <p class="eyebrow"><fmt:message key="profile.eyebrow" /></p>
        <h1><fmt:message key="profile.heading" /></h1>
        <p><fmt:message key="profile.intro" /></p>
      </div>
      <a
        class="button button-light"
        href="${pageContext.request.contextPath}/user/edit-profile"
        ><fmt:message key="profile.edit"
      /></a>
    </div>
  </section>
  <section class="container profile-page">
    <c:if test="${not empty error}"
      ><p class="alert alert-error"><c:out value="${error}" /></p></c:if
    ><c:if test="${param.updated eq '1'}"
      ><p class="alert alert-success"><fmt:message key="profile.updated" /></p
    ></c:if>
    <div class="profile-detail-grid">
      <article class="panel profile-detail">
        <div class="profile-heading">
          <span class="blood-badge blood-badge-large"
            ><c:out value="${donor.bloodGroup}"
          /></span>
          <div>
            <h2><c:out value="${donor.fullName}" /></h2>
            <span class="status-pill"
              ><fmt:message key="status.${fn:toLowerCase(donor.status)}"
            /></span>
          </div>
        </div>
        <dl class="detail-list">
          <div>
            <dt><fmt:message key="common.email" /></dt>
            <dd><c:out value="${donor.email}" /></dd>
          </div>
          <div>
            <dt><fmt:message key="common.phone" /></dt>
            <dd><c:out value="${donor.phone}" /></dd>
          </div>
          <div>
            <dt><fmt:message key="common.district" /></dt>
            <dd><c:out value="${donor.districtName}" /></dd>
          </div>
          <div>
            <dt><fmt:message key="common.upazila" /></dt>
            <dd>
              <c:choose
                ><c:when test="${not empty donor.upazilaName}"
                  ><c:out value="${donor.upazilaName}" /></c:when
                ><c:otherwise
                  ><fmt:message key="common.notProvided" /></c:otherwise
              ></c:choose>
            </dd>
          </div>
          <div>
            <dt><fmt:message key="profile.address" /></dt>
            <dd>
              <c:choose
                ><c:when test="${not empty donor.address}"
                  ><c:out value="${donor.address}" /></c:when
                ><c:otherwise
                  ><fmt:message key="common.notProvided" /></c:otherwise
              ></c:choose>
            </dd>
          </div>
          <div>
            <dt><fmt:message key="profile.lastDonationDate" /></dt>
            <dd>
              <c:choose
                ><c:when test="${not empty donor.lastDonation}"
                  ><c:out value="${donor.lastDonation}" /></c:when
                ><c:otherwise
                  ><fmt:message key="common.notRecorded" /></c:otherwise
              ></c:choose>
            </dd>
          </div>
        </dl>
      </article>
      <div class="profile-tools">
        <article class="panel">
          <h2><fmt:message key="profile.availabilityHeading" /></h2>
          <p><fmt:message key="profile.availabilityBody" /></p>
          <p class="availability-status">
            <span class="available-label"
              ><span
                class="${donor.available eq 'Y' ? '' : 'is-paused'}"
              ></span>
              <fmt:message
                key="${donor.available eq 'Y' ? 'profile.currentlyAvailable' : 'profile.currentlyPaused'}"
            /></span>
          </p>
          <form
            method="post"
            action="${pageContext.request.contextPath}/user/profile"
          >
            <input
              type="hidden"
              name="csrfToken"
              value="<c:out value='${csrfToken}'/>"
            /><input
              type="hidden"
              name="action"
              value="toggleAvailability"
            /><button
              class="button ${donor.available eq 'Y' ? 'button-outline' : ''}"
              type="submit"
            >
              <fmt:message
                key="${donor.available eq 'Y' ? 'profile.pause' : 'profile.makeAvailable'}"
              />
            </button>
          </form>
        </article>
        <article class="panel">
          <h2><fmt:message key="profile.recordDonation" /></h2>
          <p><fmt:message key="profile.donationBody" /></p>
          <form
            method="post"
            action="${pageContext.request.contextPath}/user/profile"
            class="inline-form"
          >
            <input
              type="hidden"
              name="csrfToken"
              value="<c:out value='${csrfToken}'/>"
            /><input type="hidden" name="action" value="donation" /><label
              for="lastDonation"
              ><fmt:message key="profile.lastDonationDate" /></label
            ><input
              id="lastDonation"
              name="lastDonation"
              type="date"
              max="<%= java.time.LocalDate.now() %>"
              required
            /><button class="button button-block" type="submit">
              <fmt:message key="profile.saveDonation" />
            </button>
          </form>
        </article>
      </div>
    </div>
  </section>
</main>
<jsp:include page="/includes/footer.jsp" />
