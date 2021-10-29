package com.example.demo;

import com.google.gson.Gson;
import entities.ExchangeRate;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;


public class ExchangeServlet extends HttpServlet {
    private ExchangeRate[] rates;
    private HashMap<String, Float> buy_rates = new HashMap<>();
    private HashMap<String, Float> sale_rates = new HashMap<>();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        RequestDispatcher requestDispatcher = req.getRequestDispatcher("/views/exchange.jsp");

        String str = getJSONPrivateAPI();
        Gson gson = new Gson();
        rates = gson.fromJson(str, ExchangeRate[].class);

        for (ExchangeRate er : rates) {
            buy_rates.put(er.getCcy(), Float.parseFloat(er.getBuy()));
            sale_rates.put(er.getCcy(), Float.parseFloat(er.getSale()));
        }

        req.setAttribute("exchangeRates", rates);
        requestDispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String operation = req.getParameter("operation");
        Float sum = Float.parseFloat(req.getParameter("sum"));
        String currency = req.getParameter("currency");
        HashMap<String, Float> results = new HashMap<>();
        String  res_title=sum+" "+ currency;


        if (operation.equals("Sale")) {

            req.setAttribute("title", "Продать "+res_title);
            if (!currency.equalsIgnoreCase("UAN")) {
                sum *= buy_rates.get(currency);
                results.put("UAN", sum);
            }
            //перевод в валюту по курсу продажи
            for (Map.Entry item : sale_rates.entrySet()) {
                if( !item.getKey().toString().equals(currency) && !item.getKey().toString().equals("BTC") )
                results.put(item.getKey().toString(), sum / (Float) item.getValue());
            }

        } else {

            req.setAttribute("title", "Купить "+res_title);
            if (!currency.equalsIgnoreCase("UAN")) {
                sum *= sale_rates.get(currency);
                results.put("UAN", sum);
            }

            //перевод в валюту по курсу покупки
            for (Map.Entry item : buy_rates.entrySet()) {
                if( !item.getKey().toString().equals(currency) && !item.getKey().toString().equals("BTC"))
                    results.put(item.getKey().toString(), sum / (Float) item.getValue());

            }
        }
        req.setAttribute("_results", results);

        doGet(req, resp);
    }

    private String getJSONPrivateAPI() throws IOException {
        URL url = new URL("https://api.privatbank.ua/p24api/pubinfo?json&exchange&coursid=5");
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setConnectTimeout(5000);
        connection.setReadTimeout(5000);

        try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
            String inputLine;
            StringBuilder content = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            return content.toString();
        } catch (final Exception ex) {
            ex.printStackTrace();
            return "";
        }

    }

    public ExchangeRate[] getRates() {
        return rates;
    }
}
