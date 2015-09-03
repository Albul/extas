/**
 * Copyright (c) 2011-2015 Alexandr Albul
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.extas.utils {

import deng.fzip.*;

import flash.events.*;
import flash.net.FileReference;
import flash.utils.*;
import flash.utils.ByteArray;

public class XlsxUtils {

	public static var openXMLNS:Namespace = new Namespace("http://schemas.openxmlformats.org/spreadsheetml/2006/main");
	public static var doubleSpace:RegExp = /  /g;

	private var _fileName:String;
	private var _zipData:FZip;
	private var _sharedStringsCache:XML;
	private var _worksheetCache:Dictionary = new Dictionary();

	default xml namespace = openXMLNS;

	public function XlsxUtils(fileName:String = null) {
		_fileName = fileName;
		_zipData = new FZip();
		createXlsx();
	}

	//--------------------------------------------------------------------------
	//
	//  Public methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Create an XLSX file using FZip and a set of predefined strings
	 */
	public function createXlsx():void {
		addFile('[Content_Types].xml', excelStrings['[Content_Types].xml']);
		addFile('_rels/.rels', excelStrings['_rels/.rels']);
		addFile('xl/workbook.xml', excelStrings['xl/workbook.xml']);
		addFile('xl/_rels/workbook.xml.rels', excelStrings['xl/_rels/workbook.xml.rels']);
		addFile('xl/worksheets/sheet1.xml', excelStrings['xl/worksheets/sheet1.xml']);
		addFile('xl/sharedStrings.xml', excelStrings['xl/sharedStrings.xml']);
	}

	/**
	 * Returns current xlsx file
	 * @return ByteArray representation of current xlsx file
	 */
	public function getXlsxFile():ByteArray {
		flushBuffer();
		var ba:ByteArray = new ByteArray();
		_zipData.serialize(ba);
		return ba;
	}

	/**
	 * Calls the window for saving current xlsx file
	 * @param completeHandler function that will be called after saving the file
	 */
	public function saveXlsxFile(completeHandler:Function = null):void {
		var fileRef:FileReference = new FileReference();
		if (completeHandler != null) {
			fileRef.addEventListener(Event.COMPLETE, completeHandler);
		}
		fileRef.save(getXlsxFile(), _fileName);
	}

	/**
	 * Returns the openxml namespace as a Namespace object
	 * @return the openxml namespace as a Namespace object
	 */
	public function getNamespace():Namespace {
		return openXMLNS;
	}

	/**
	 * Set a value to the certain cell
	 * @param rowIndex index of row
	 * @param colIndex index of column
	 * @param value value to put in cell
	 */
	public function setCellContent(rowIndex:int, colIndex:int, value:String):void {
		var sheet:XML = worksheetbyId(1);	// TODO support more than one sheet
		var sharedStr:XML = sharedStrings;

		sharedStr.appendChild(<si></si>);
		sharedStr.si[colIndex].appendChild(<t>{value}</t>);
		sharedStr.@count = colIndex + 1;
		sharedStr.@uniqueCount = colIndex + 1;

		while (sheet.sheetData.row[rowIndex] == null) {
			sheet.sheetData.appendChild(<row></row>);
		}

		sheet.sheetData.row[rowIndex].@r = (rowIndex + 1).toString();
		sheet.sheetData.row[rowIndex].@spans = "1:3";// Magic number

		while (sheet.sheetData.row[rowIndex].c[colIndex] == null) {
			sheet.sheetData.row[rowIndex].appendChild(<c></c>);
		}
		sheet.sheetData.row[rowIndex].c[colIndex].@r = getColName(rowIndex, colIndex);
		sheet.sheetData.row[rowIndex].c[colIndex].@t = "s";	// Type of cell
		sheet.sheetData.row[rowIndex].c[colIndex].appendChild(<v>{(rowIndex + colIndex).toString()}</v>);
	}

	//--------------------------------------------------------------------------
	//
	//  Private methods
	//
	//--------------------------------------------------------------------------


	private function flushBuffer():void {
		if (_sharedStringsCache != null) {
			saveFile('xl/sharedStrings.xml', _xmlHeader +
					_sharedStringsCache.normalize().toXMLString().split("\n").join("").replace(doubleSpace, ""));
		}
		for (var id:String in _worksheetCache) {
			_worksheetCache[id].normalize();
			saveFile("xl/worksheets/sheet" + id + ".xml", _xmlHeader +
					_worksheetCache[id].normalize().toXMLString().split("\n").join("").replace(doubleSpace, ""));
		}
	}

	private function retrieveXML(path:String):XML {
		return convertToOpenXMLNS(_zipData.getFileByName(path).getContentAsString(false));
	}

	private function convertToOpenXMLNS(s:String):XML {
		XML.ignoreProcessingInstructions = true;
		return XML(s).normalize();
	}

	private function getColName(rowIndex:int, colIndex:int):String {
		var result:String;
		if (colIndex <= 26) {	// TODO support more than 26 columns
			result = String.fromCharCode(65 + colIndex) + (rowIndex + 1).toString();
		}
		return result;
	}

	private function addFile(file:String, value:String):void {
		var bytes:ByteArray = new ByteArray();
		bytes.writeUTFBytes(value);
		_zipData.addFile(file, bytes);
	}

	private function saveFile(file:String, value:String):void {
		var bytes:ByteArray = new ByteArray();
		bytes.writeUTFBytes(value);
		_zipData.getFileByName(file).setContent(bytes);
	}

	private function worksheetbyId(id:Number):XML {
		if (!_worksheetCache[id]) {
			_worksheetCache[id] = retrieveXML("xl/worksheets/sheet" + id + ".xml");
		}
		return _worksheetCache[id];
	}

	private function get sharedStrings():XML {
		if (!_sharedStringsCache) {
			_sharedStringsCache = retrieveXML("xl/sharedStrings.xml");
		}
		return _sharedStringsCache;
	}

	//--------------------------------------------------------------------------
	//
	//  Pre-defined strings to build a minimal XLSX file
	//
	//--------------------------------------------------------------------------

	public static var excelStrings:Object = {
		"_rels/.rels": '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\
	<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>\
</Relationships>',

		"xl/_rels/workbook.xml.rels": '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">\
	<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>\
	<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>\
</Relationships>',

		"[Content_Types].xml": '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">\
	<Default Extension="xml" ContentType="application/xml"/>\
	<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>\
	<Default Extension="jpeg" ContentType="image/jpeg"/>\
	<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>\
	<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>\
	<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>\
</Types>',

		"xl/workbook.xml": '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">\
	<fileVersion appName="xl" lastEdited="5" lowestEdited="5" rupBuild="24816"/>\
	<workbookPr showInkAnnotation="0" autoCompressPictures="0"/>\
	<bookViews>\
		<workbookView xWindow="0" yWindow="0" windowWidth="25600" windowHeight="19020" tabRatio="500"/>\
	</bookViews>\
	<sheets>\
		<sheet name="Sheet1" sheetId="1" r:id="rId1"/>\
	</sheets>\
</workbook>',

		"xl/worksheets/sheet1.xml": '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">\
	<sheetData></sheetData>\
</worksheet>',

		"xl/sharedStrings.xml": '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\
<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="0" uniqueCount="0"></sst>'
	};

	public static var _xmlHeader:String = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\r\n';
}
}
