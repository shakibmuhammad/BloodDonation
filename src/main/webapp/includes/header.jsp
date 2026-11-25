<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@
include file="/WEB-INF/jspf/lang.jspf" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="${sessionScope.bloodlinkLocale}">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#8B0000" />
    <title>
      <c:choose> <c:when test="${not empty pageTitleKey}"> <fmt:message
      key="${pageTitleKey}" /> </c:when> <c:otherwise> <fmt:message
      key="site.title" /> </c:otherwise> </c:choose>
    </title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Hind+Siliguri:wght@400;500;600;700&family=Inter:wght@400;500;600;700;800&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/responsive.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/searchable-select.css"
    />
  </head>

  <body data-context-path="${pageContext.request.contextPath}">
    <a class="skip-link" href="#main">
      <fmt:message key="nav.skip" />
    </a>
    <jsp:include page="navbar.jsp" />
    <c:if test="${param.sessionExpired eq '1'}">
      <div class="container">
        <p class="alert alert-error">
          <fmt:message key="login.sessionExpired" />
        </p>
      </div>
    </c:if>
  </body>
</html>
