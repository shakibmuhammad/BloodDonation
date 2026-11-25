<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
include file="/WEB-INF/jspf/lang.jspf" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitleKey" scope="request" value="page.contact" />
<jsp:include page="/includes/header.jsp" />
<main id="main" class="page-main">
  <section class="page-hero">
    <div class="container">
      <p class="eyebrow">
        <fmt:message key="contact.eyebrow" />
      </p>
      <h1>
        <fmt:message key="contact.heading" />
      </h1>
      <p>
        <fmt:message key="contact.intro" />
      </p>
    </div>
  </section>
  <section class="container contact-layout">
    <div class="contact-copy">
      <h2>
        <fmt:message key="contact.supportHeading" />
      </h2>
      <p>
        <fmt:message key="contact.supportBody" />
      </p>
      <a class="contact-method" href="mailto:support@bloodlink.local"
        ><span class="contact-icon">✉</span
        ><span
          ><small>
            <fmt:message key="common.email" /> </small
          ><strong>
            <fmt:message key="contact.email" /> </strong></span></a
      ><a class="contact-method" href="tel:+8801700000000"
        ><span class="contact-icon">☎</span
        ><span
          ><small>
            <fmt:message key="common.phone" /> </small
          ><strong>
            <fmt:message key="contact.phone" /> </strong></span
      ></a>
      <p class="medical-note">
        <fmt:message key="contact.urgentNote" />
      </p>
    </div>
    <div class="panel contact-panel">
      <p class="eyebrow">
        <fmt:message key="contact.helpful" />
      </p>
      <h2>
        <fmt:message key="contact.findNeed" />
      </h2>
      <a class="resource-link" href="${pageContext.request.contextPath}/search">
        <fmt:message key="contact.search" /> <span>→</span> </a
      ><a
        class="resource-link"
        href="${pageContext.request.contextPath}/request"
      >
        <fmt:message key="request.heading" /> <span>→</span> </a
      ><a
        class="resource-link"
        href="${pageContext.request.contextPath}/user/profile"
      >
        <fmt:message key="contact.profile" /> <span>→</span> </a
      ><a
        class="resource-link"
        href="${pageContext.request.contextPath}/about.jsp"
      >
        <fmt:message key="contact.about" /> <span>→</span>
      </a>
    </div>
  </section>
</main>
<jsp:include page="/includes/footer.jsp" />
