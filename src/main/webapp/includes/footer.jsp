<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/lang.jspf" %>
<footer class="site-footer">
  <div class="container footer-grid">
    <div><a class="brand footer-brand" href="${pageContext.request.contextPath}/"><svg class="brand-mark" viewBox="0 0 40 48" aria-hidden="true"><path d="M20 2C15 11 5 22 5 31a15 15 0 0 0 30 0C35 22 25 11 20 2Z" fill="currentColor"/></svg><span>Blood<span class="brand-light">Link</span></span></a><p><fmt:message key="footer.description"/></p></div>
    <div><strong><fmt:message key="footer.explore"/></strong><a href="${pageContext.request.contextPath}/search"><fmt:message key="footer.findDonor"/></a><a href="${pageContext.request.contextPath}/request"><fmt:message key="footer.postRequest"/></a><a href="${pageContext.request.contextPath}/requests"><fmt:message key="footer.openRequests"/></a><a href="${pageContext.request.contextPath}/donate.jsp"><fmt:message key="nav.donate"/></a></div>
    <div><strong><fmt:message key="footer.contactHeading"/></strong><a href="${pageContext.request.contextPath}/contact.jsp"><fmt:message key="nav.contact"/></a><a href="${pageContext.request.contextPath}/admin/login"><fmt:message key="footer.administration"/></a></div>
  </div>
  <div class="container footer-bottom"><fmt:message key="footer.copyright"/></div>
</footer>
<script src="${pageContext.request.contextPath}/assets/js/app.js" defer></script>
<script src="${pageContext.request.contextPath}/assets/js/searchable-select.js" defer></script>
</body>
</html>
