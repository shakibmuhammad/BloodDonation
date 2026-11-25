<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@
include file="/WEB-INF/jspf/lang.jspf" %><%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %><c:set
  var="pageTitleKey"
  scope="request"
  value="page.error500"
/><jsp:include page="/includes/header.jsp" />
<main id="main" class="error-page container">
  <span class="error-code">500</span>
  <p class="eyebrow"><fmt:message key="error.500Eyebrow" /></p>
  <h1><fmt:message key="error.500Heading" /></h1>
  <p><fmt:message key="error.500Body" /></p>
  <a class="button" href="${pageContext.request.contextPath}/"
    ><fmt:message key="error.home"
  /></a>
</main>
<jsp:include page="/includes/footer.jsp" />
