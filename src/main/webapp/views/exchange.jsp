<%@ page import="entities.ExchangeRate" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: User
  Date: 15.10.2021
  Time: 21:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <style>
        body {
            background: url("https://images.unsplash.com/photo-1621280336935-ed7cae618aac?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=870&q=80;");
            background-size: cover;
            height: 100%;
            overflow: hidden;
        }
        .caption-style {
            caption-side: top;
            color: black;
            text-shadow: 1px 1px 2px lightblue;
        }
    </style>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <title>Конвертер валют Privat24</title>
</head>
<body>
<main>
    <div class="container p-4">
        <div class="row justify-content-md-center"
        ><h2 class="col col col-lg-6" style="color: black;
        text-shadow: 1px 1px 2px cyan, 0 0 1em lightblue, 0 0 0.2em lightblue;
        font-style: oblique;">Курсы валют ПриватБанка</h2>
        </div>
        <div class="row justify-content-md-center">

            <table class="table table-success table-striped w-75 col col-lg-6 shadow-sm p-3 mb-5 bg-body rounded">
                <thead>
                <tr>
                    <th scope="col">Код валюты</th>
                    <th scope="col">Код нац.валюты</th>
                    <th scope="col">Курс покупки</th>
                    <th scope="col">Курс продажи</th>
                </tr>
                </thead>
                <tbody>
                <%
                    ExchangeRate[] list = (ExchangeRate[]) request.getAttribute("exchangeRates");
                    for (ExchangeRate ent : list) {
                        out.print("<tr><th scope=\"row\">" + ent.getCcy() + "</th>");
                        out.print("<td>" + ent.getBase_ccy() + "</td>");
                        out.print("<td>" + ent.getBuy() + "</td>");
                        out.print("<td>" + ent.getSale() + "</td> </tr>");
                    }
                %>
                </tbody>
            </table>
        </div>
        <div class="row justify-content-md-center">
            <div class="col col-md-6">
                <form class="g-3 w-50  bg-light rounded shadow p-3 mb-5" method="post">
                    <h5>Конвертер валют</h5>
                    <div class="mb-3 m-1">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="operation" id="inlineRadioSale"
                                   value="Sale" checked>
                            <label class="form-check-label" for="inlineRadioSale">Продать</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="operation" id="inlineRadioBuy"
                                   value="Buy">
                            <label class="form-check-label" for="inlineRadioBuy">Купить</label>
                        </div>

                    </div>
                    <div class="flex-box m-1">
                        <input type="number" class="form-control" name="sum" id="sum" placeholder="Сумма" value="0">
                        <select name="currency" class="form-control">
                            <option value="USD">USD</option>
                            <option value="EUR">EUR</option>
                            <option value="RUR">RUR</option>
                        </select>
                    </div>
                    <div class="mb-3 m-1">
                        <button type="submit" class="btn  btn-secondary mb-3">Выполнить</button>
                    </div>
                </form>
            </div>
            <div class="col col-md-3">
                <table class="table table-bordered table-success  shadow-sm p-3 mb-5 bg-body rounded"
                       style="background-color: cadetblue">
                    <%
                        if (request.getAttribute("title") != null) {
                            String title = request.getAttribute("title").toString();
                            out.print("<h5 class=\"caption-style\">" + title + "</h5>");
                        }
                    %>
                    <tbody>
                    <%
                        if (request.getAttribute("_results") != null) {
                            HashMap<String, Float> results = (HashMap<String, Float>) request.getAttribute("_results");
                            for (Map.Entry item : results.entrySet()) {
                                out.print("<tr><td>" + item.getValue() + "</td>");
                                out.print("<td>" + item.getKey() + "</td> </tr>");
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"
        integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"
        integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF"
        crossorigin="anonymous"></script>
</body>
</html>
