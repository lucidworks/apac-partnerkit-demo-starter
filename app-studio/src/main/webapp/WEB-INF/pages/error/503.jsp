<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<html>
<head>
    <meta charset="utf-8">
    <title>This service is currently unavailable</title>
    <link rel="stylesheet" href="/dist/main.css">
    <style>
        body {
            background: #f0f0f0;
        }

        h1 {
            margin: 0 10px;
            font-size: 50px;
            text-align: center;
            color: #737373;
        }

        h1 span {
            color: #bbb;
        }

        h3 {
            margin: 1.5em 0 0.5em;
        }

        p {
            margin: 1em 0;
        }

        ul {
            padding: 0 0 0 40px;
            margin: 1em 0 0;
        }

        .error-container {
            color: #737373;
            font-size: 20px;
            max-width: 520px;
            _width: 520px;
            padding: 30px 20px 50px;
            border: 1px solid #b3b3b3;
            border-radius: 4px;
            margin: 0 auto;
            position: relative;
            top: 30px;
            box-shadow: 0 1px 10px #a7a7a7, inset 0 1px 0 #fff;
            background: #fcfcfc;
        }

        .error-content {
            max-width: 380px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-content">
        <h1>Service unavailable <span>:(</span></h1>
        <p>${requestScope['javax.servlet.error.message']}</p>
    </div>
</div>
</body>
</html>
