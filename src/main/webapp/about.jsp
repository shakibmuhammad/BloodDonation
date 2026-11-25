<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
include file="/WEB-INF/jspf/lang.jspf" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitleKey" scope="request" value="page.about" />
<jsp:include page="/includes/header.jsp" />
<main id="main" class="page-main">
  <section class="page-hero">
    <div class="container">
      <p class="eyebrow">
        <fmt:message key="about.eyebrow" />
      </p>
      <h1>
        <fmt:message key="about.heading" />
      </h1>
      <p>
        <fmt:message key="about.intro" />
      </p>
    </div>
  </section>
  <section class="container content-prose">
    <div class="prose-block">
      <h2>
        <fmt:message key="about.sectionHeading" />
      </h2>
      <p>
        <fmt:message key="about.body1" />
      </p>
      <p>
        <fmt:message key="about.body2" />
      </p>
    </div>
    <div class="values-grid">
      <article>
        <span>01</span>
        <h3>
          <fmt:message key="about.value1.title" />
        </h3>
        <p>
          <fmt:message key="about.value1.body" />
        </p>
      </article>
      <article>
        <span>02</span>
        <h3>
          <fmt:message key="about.value2.title" />
        </h3>
        <p>
          <fmt:message key="about.value2.body" />
        </p>
      </article>
      <article>
        <span>03</span>
        <h3>
          <fmt:message key="about.value3.title" />
        </h3>
        <p>
          <fmt:message key="about.value3.body" />
        </p>
      </article>
    </div>
    <p class="medical-note">
      <fmt:message key="about.note" />
    </p>
  </section>
</main>
<jsp:include page="/includes/footer.jsp" />
