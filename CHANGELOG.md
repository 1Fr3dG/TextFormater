# TextFormater
a pod to convert String to NSAttributedString

## LAST
[![CI Status](http://img.shields.io/travis/1Fr3dG/TextFormater.svg?style=flat)](https://travis-ci.org/1Fr3dG/TextFormater)
[![Version](https://img.shields.io/cocoapods/v/TextFormater.svg?style=flat)](http://cocoapods.org/pods/TextFormater)
[![License](https://img.shields.io/cocoapods/l/TextFormater.svg?style=flat)](http://cocoapods.org/pods/TextFormater)
[![Platform](https://img.shields.io/cocoapods/p/TextFormater.svg?style=flat)](http://cocoapods.org/pods/TextFormater)

* Surplus `</>` will be ignore
	
	So wrong structure may not cause app be killed, but note format result may be incorrect

## 1.1.4

* support spm

## 1.1.3

* `format(String?)` returns `NSAttributedString?` now. nil for nil.

## 1.1.2

* add `dynamicFormatDelegate`

## 1.1.1

* add OSX screenshot

## 1.1.0

* add OSX support

## 1.0.1

* add color "clear"
* write readme.me

## 1.0.0
Moved from my last project, prepare for next.

In my last project, this class was used to generate view from plain text which read from json.