!function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var a="function"==typeof require&&require;if(!f&&a)return a(i,!0);if(u)return u(i,!0);var c=new Error("Cannot find module '"+i+"'");throw c.code="MODULE_NOT_FOUND",c}var l=n[i]={exports:{}};e[i][0].call(l.exports,function(r){var n=e[i][1][r];return o(n?n:r)},l,l.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}({1:[function(r){var e=r("jquery");e("body > .container").html('<p class="text">Hello, World!</p>')},{jquery:"jquery"}]},{},[1]);