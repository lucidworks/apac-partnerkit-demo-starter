<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="app" uri="/lucidworks/app" %>
<%@ taglib prefix="version" uri="/twigkit" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Starter App</title>
    <base href="${app:contextPath(pageContext.request)}/"/>
    <meta name="description" content="">
    <meta name="author" content="Twigkit">
    <meta name="viewport" content="minimal-ui, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=440">
    <link rel="icon" href="${app:contextPath(pageContext.request)}/favicon.ico?v=3" type="image/x-icon"/>
    <link rel="stylesheet" href="${app:contextPath(pageContext.request)}${version:cacheBust('/dist/main.css')}">

    <!--[if lt IE 9]>
    <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
</head>

<body class="login app-studio-login">

<div class="login-content" ng-controller="loginCtrl">
    <widget:login-form
        method="POST"
        action="${app:contextPath(pageContext.request)}${'/j_spring_security_check'}"
        append-hash-to-action="true"
        branding-class="branding"
        logo="${app:contextPath(pageContext.request)}${'/assets/squarelogo.png'}"
        logo-width="136"
        title="Starter App"
        title-element="h1"
        username-class="field required field-email"
        username-label="Username"
        password-class="field required field-password"
        password-label="Password"
        remember="false"
        access-denied="login_error"
    ></widget:login-form>

</div>

<script type="text/javascript"
        src="${app:contextPath(pageContext.request)}${version:cacheBust('/dist/vendor.bundle.js')}"></script>
<script type="text/javascript"
        src="${app:contextPath(pageContext.request)}${version:cacheBust('/dist/app.bundle.js')}"></script>

<script>
    angular.module('lightning').constant('contextPath', '${app:contextPath(pageContext.request)}');
</script>

</body>
</html>
