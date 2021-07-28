<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" uri="/lucidworks/app" %>
<%@ taglib prefix="version" uri="/twigkit" %>

<!doctype html>
<html class="no-js">

<head>
    <base href="${app:contextPath(pageContext.request)}/"/>
    <meta charset="utf-8">
    <title>Starter App</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">

    <%--Uncomment to override IE Compatibility View settings--%>
    <%--<meta http-equiv="x-ua-compatible" content="ie=edge">--%>

    <link rel="icon" href="${app:contextPath(pageContext.request)}/favicon.ico?v=3" type="image/x-icon"/>
    <link rel="stylesheet" href="${app:contextPath(pageContext.request)}${version:cacheBust('/dist/main.css')}">

    <!-- AnyChart (https://www.anychart.com) -->
    <!-- NOTE!! AnyChart is a commercial product. Code in this project serves as an example of the library's capabilities  -->
    <!--        To use AnyChart in implementations, contact https://www.anychart.com/buy/  -->
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-base.min.js"></script>
    <script src="https://cdn.anychart.com/releases/v8/js/anychart-tag-cloud.min.js"></script>
</head>

<body>
<ui-view autoscroll="true" class="routes-container"></ui-view>

<div class="tk-stl-notifications"></div>

<script type="text/javascript"
        src="${app:contextPath(pageContext.request)}${version:cacheBust('/dist/vendor.bundle.js')}"></script>
<script type="text/javascript"
        src="${app:contextPath(pageContext.request)}${version:cacheBust('/dist/app.bundle.js')}"></script>
</body>

</html>
