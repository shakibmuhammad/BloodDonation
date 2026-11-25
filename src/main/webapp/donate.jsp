<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/lang.jspf" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitleKey" scope="request" value="page.donate"/>
<fmt:setBundle basename="i18n.donation" var="donationConfig"/>
<fmt:message key="bkash.number" bundle="${donationConfig}" var="bkashNumber"/>
<fmt:message key="nagad.number" bundle="${donationConfig}" var="nagadNumber"/>
<fmt:message key="rocket.number" bundle="${donationConfig}" var="rocketNumber"/>
<fmt:message key="bank.name" bundle="${donationConfig}" var="bankName"/>
<fmt:message key="bank.accountName" bundle="${donationConfig}" var="bankAccountName"/>
<fmt:message key="bank.accountNumber" bundle="${donationConfig}" var="bankAccountNumber"/>
<fmt:message key="bank.branch" bundle="${donationConfig}" var="bankBranch"/>
<fmt:message key="bank.routing" bundle="${donationConfig}" var="bankRouting"/>
<fmt:message key="contact.email" bundle="${donationConfig}" var="contactEmail"/>
<fmt:message key="contact.phone" bundle="${donationConfig}" var="contactPhone"/>
<jsp:include page="/includes/header.jsp"/>
<main id="main" class="page-main donate-page">
  <section class="donate-hero">
    <div class="container donate-hero-inner">
      <div>
        <p class="eyebrow"><fmt:message key="donate.eyebrow"/></p>
        <h1><fmt:message key="donate.heading"/></h1>
        <p><fmt:message key="donate.intro"/></p>
        <a class="button button-light" href="#donation-options"><fmt:message key="donate.cta"/></a>
      </div>
      <aside class="donate-hero-note">
        <span aria-hidden="true">♥</span>
        <p><fmt:message key="donate.heroNote"/></p>
      </aside>
    </div>
  </section>

  <div class="container donate-content">
    <section class="donate-notice" role="note">
      <strong><fmt:message key="donate.placeholderTitle"/></strong>
      <p><fmt:message key="donate.placeholderBody"/></p>
    </section>

    <section class="donate-why" aria-labelledby="donate-why-title">
      <div class="donate-section-heading">
        <p class="eyebrow"><fmt:message key="donate.whyEyebrow"/></p>
        <h2 id="donate-why-title"><fmt:message key="donate.whyTitle"/></h2>
        <p><fmt:message key="donate.whyIntro"/></p>
      </div>
      <div class="donate-reasons">
        <article class="donate-reason">
          <span aria-hidden="true">01</span>
          <h3><fmt:message key="donate.useEmergencyTitle"/></h3>
          <p><fmt:message key="donate.useEmergencyBody"/></p>
        </article>
        <article class="donate-reason">
          <span aria-hidden="true">02</span>
          <h3><fmt:message key="donate.useCampsTitle"/></h3>
          <p><fmt:message key="donate.useCampsBody"/></p>
        </article>
        <article class="donate-reason">
          <span aria-hidden="true">03</span>
          <h3><fmt:message key="donate.useDonorsTitle"/></h3>
          <p><fmt:message key="donate.useDonorsBody"/></p>
        </article>
      </div>
    </section>

    <section id="donation-options" class="donate-methods" aria-labelledby="donate-payment-title">
      <div class="donate-section-heading">
        <p class="eyebrow"><fmt:message key="donate.paymentEyebrow"/></p>
        <h2 id="donate-payment-title"><fmt:message key="donate.paymentHeading"/></h2>
        <p><fmt:message key="donate.paymentIntro"/></p>
      </div>
      <div class="panel donate-amounts" aria-labelledby="donate-amount-title">
        <h3 id="donate-amount-title"><fmt:message key="donate.amountHeading"/></h3>
        <div class="amount-options" role="group" aria-label="<fmt:message key='donate.amountHeading'/>">
          <button class="amount-button" type="button" data-donate-amount="100" aria-pressed="false"><fmt:message key="donate.amount100"/></button>
          <button class="amount-button" type="button" data-donate-amount="500" aria-pressed="false"><fmt:message key="donate.amount500"/></button>
          <button class="amount-button" type="button" data-donate-amount="1000" aria-pressed="false"><fmt:message key="donate.amount1000"/></button>
        </div>
        <label for="donateCustomAmount"><fmt:message key="donate.customLabel"/></label>
        <input id="donateCustomAmount" type="number" min="1" step="1" inputmode="numeric" placeholder="<fmt:message key='donate.customPlaceholder'/>"/>
        <p class="donate-small-note"><fmt:message key="donate.amountNote"/></p>
      </div>

      <div class="payment-grid">
        <article class="panel payment-card">
          <div class="payment-card-heading"><span class="payment-mark bkash-mark" aria-hidden="true">b</span><h3>bKash</h3></div>
          <dl class="payment-details">
            <div><dt><fmt:message key="donate.paymentNumber"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${bkashNumber}"/></dd></div>
            <div><dt><fmt:message key="donate.accountType"/></dt><dd><fmt:message key="donate.accountTypePlaceholder"/></dd></div>
            <div><dt><fmt:message key="donate.referenceLabel"/></dt><dd><fmt:message key="donate.referenceText"/></dd></div>
          </dl>
          <button class="button button-outline copy-number" type="button" data-copy-value="<c:out value='${bkashNumber}'/>"><fmt:message key="donate.copyNumber"/></button>
        </article>
        <article class="panel payment-card">
          <div class="payment-card-heading"><span class="payment-mark nagad-mark" aria-hidden="true">N</span><h3>Nagad</h3></div>
          <dl class="payment-details">
            <div><dt><fmt:message key="donate.paymentNumber"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${nagadNumber}"/></dd></div>
            <div><dt><fmt:message key="donate.accountType"/></dt><dd><fmt:message key="donate.accountTypePlaceholder"/></dd></div>
            <div><dt><fmt:message key="donate.referenceLabel"/></dt><dd><fmt:message key="donate.referenceText"/></dd></div>
          </dl>
          <button class="button button-outline copy-number" type="button" data-copy-value="<c:out value='${nagadNumber}'/>"><fmt:message key="donate.copyNumber"/></button>
        </article>
        <article class="panel payment-card">
          <div class="payment-card-heading"><span class="payment-mark rocket-mark" aria-hidden="true">R</span><h3>Rocket</h3></div>
          <dl class="payment-details">
            <div><dt><fmt:message key="donate.paymentNumber"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${rocketNumber}"/></dd></div>
            <div><dt><fmt:message key="donate.accountType"/></dt><dd><fmt:message key="donate.accountTypePlaceholder"/></dd></div>
            <div><dt><fmt:message key="donate.referenceLabel"/></dt><dd><fmt:message key="donate.referenceText"/></dd></div>
          </dl>
          <button class="button button-outline copy-number" type="button" data-copy-value="<c:out value='${rocketNumber}'/>"><fmt:message key="donate.copyNumber"/></button>
        </article>
        <article class="panel payment-card bank-card">
          <div class="payment-card-heading"><span class="payment-mark bank-mark" aria-hidden="true">৳</span><h3><fmt:message key="donate.bankTitle"/></h3></div>
          <dl class="payment-details">
            <div><dt><fmt:message key="donate.bankNameLabel"/></dt><dd><c:out value="${bankName}"/></dd></div>
            <div><dt><fmt:message key="donate.accountNameLabel"/></dt><dd><c:out value="${bankAccountName}"/></dd></div>
            <div><dt><fmt:message key="donate.paymentNumber"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${bankAccountNumber}"/></dd></div>
            <div><dt><fmt:message key="donate.branchLabel"/></dt><dd><c:out value="${bankBranch}"/></dd></div>
            <div><dt><fmt:message key="donate.routingLabel"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${bankRouting}"/></dd></div>
            <div><dt><fmt:message key="donate.referenceLabel"/></dt><dd><fmt:message key="donate.referenceText"/></dd></div>
          </dl>
          <button class="button button-outline copy-number" type="button" data-copy-value="<c:out value='${bankAccountNumber}'/>"><fmt:message key="donate.copyNumber"/></button>
        </article>
      </div>
      <p id="donateCopyStatus" class="donate-copy-status" role="status" aria-live="polite"
         data-copy-success="<fmt:message key='donate.copySuccess'/>"
         data-copy-failed="<fmt:message key='donate.copyFailed'/>"></p>
    </section>

    <section class="donate-steps" aria-labelledby="donate-steps-title">
      <div class="donate-section-heading">
        <p class="eyebrow"><fmt:message key="donate.stepsEyebrow"/></p>
        <h2 id="donate-steps-title"><fmt:message key="donate.stepsTitle"/></h2>
      </div>
      <ol class="donate-step-list">
        <li><span>1</span><p><fmt:message key="donate.stepOne"/></p></li>
        <li><span>2</span><p><fmt:message key="donate.stepTwo"/></p></li>
        <li><span>3</span><p><fmt:message key="donate.stepThree"/></p></li>
      </ol>
      <label class="transaction-label" for="donateTransactionId"><fmt:message key="donate.transactionIdLabel"/></label>
      <input id="donateTransactionId" type="text" maxlength="80" autocomplete="off" placeholder="<fmt:message key='donate.transactionIdPlaceholder'/>"/>
      <p class="donate-small-note"><fmt:message key="donate.transactionIdNote"/></p>
    </section>

    <section class="donate-bottom-grid">
      <div class="panel donate-faq">
        <h2><fmt:message key="donate.faqTitle"/></h2>
        <details><summary><fmt:message key="donate.faqOneQuestion"/></summary><p><fmt:message key="donate.faqOneAnswer"/></p></details>
        <details><summary><fmt:message key="donate.faqTwoQuestion"/></summary><p><fmt:message key="donate.faqTwoAnswer"/></p></details>
      </div>
      <aside class="panel donate-contact">
        <h2><fmt:message key="donate.contactTitle"/></h2>
        <p><fmt:message key="donate.contactIntro"/></p>
        <dl class="payment-details">
          <div><dt><fmt:message key="donate.emailLabel"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${contactEmail}"/></dd></div>
          <div><dt><fmt:message key="donate.phoneLabel"/></dt><dd><fmt:message key="donate.placeholderPrefix"/> <c:out value="${contactPhone}"/></dd></div>
        </dl>
      </aside>
    </section>

    <aside class="donate-privacy">
      <h2><fmt:message key="donate.privacyTitle"/></h2>
      <p><fmt:message key="donate.privacyBody"/></p>
    </aside>
  </div>
</main>
<jsp:include page="/includes/footer.jsp"/>
