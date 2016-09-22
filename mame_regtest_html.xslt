<?xsl version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<!-- input parameter is name of the test ran: $mameRegtest -->
<!-- start with "xsltproc -stringparam mameRegtest mess_gbpocket mame_regtest.xslt mame_regtest.xml"
     to get the results for the test case named 'mess_gbpocket' -->
<xsl:output method="xml" indent="no" />

<xsl:param name="mameRegtest"/>

<xsl:template match="/">
	<xsl:for-each select="/mame_regtest/*">
		<xsl:if test="local-name()=$mameRegtest">
			<xsl:variable name="output_folder" select="./option[@name='output_folder']/@value" />
			<xsl:variable name="use_dummy_root" select="./option[@name='use_dummy_root']/@value" />
			<xsl:variable name="device_file" select="./option[@name='device_file']/@value" />
			<xsl:variable name="print_xpath_results" select="./option[@name='print_xpath_results']/@value" />
			<xsl:variable name="store_output" select="./option[@name='store_output']/@value" />
			<xsl:if test="$use_dummy_root and $store_output">
<html>
<head>
<title>mame_regtest results for test '<xsl:value-of select="$mameRegtest"/>'</title>
</head>
<body>
<h3>mame_regtest results for test '<xsl:value-of select="$mameRegtest"/>'</h3>
				<xsl:for-each select="document(concat($output_folder,'/xpath_results.xml'))/xpath_result/*">
					<xsl:variable name="driver_name" select="./@name" />
					<!-- handle regular system results -->
					<xsl:if test="$use_dummy_root">
						<xsl:call-template name="handle_system_files">
							<xsl:with-param name="output_folder" select="$output_folder" />
							<xsl:with-param name="driver_name" select="$driver_name" />
						</xsl:call-template>
					</xsl:if>
					<!-- handle possible device file -->
					<xsl:if test="$device_file and $use_dummy_root">
						<xsl:call-template name="handle_device_file">
							<xsl:with-param name="output_folder" select="$output_folder" />
							<xsl:with-param name="driver_name" select="$driver_name" />
							<xsl:with-param name="device_file" select="$device_file" />
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
</body>
</html>
			</xsl:if>
		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="handle_system_files">
	<xsl:param name="output_folder" />
	<xsl:param name="driver_name" />

	<xsl:call-template name="check_files">
		<xsl:with-param name="output_folder" select="$output_folder" />
		<xsl:with-param name="base_name" select="$driver_name" />
		<xsl:with-param name="driver_name" select="$driver_name" />
		<xsl:with-param name="description" select="$driver_name" />
	</xsl:call-template>
</xsl:template>

<xsl:template name="handle_device_file">
	<xsl:param name="output_folder"/>
	<xsl:param name="driver_name"/>
	<xsl:param name="device_file"/>
	<xsl:for-each select="document($device_file)/images/image">
		<xsl:variable name="base_name" select="concat($driver_name,'_sfw', format-number(position()-1,'00000'))" />
		<xsl:call-template name="check_files">
			<xsl:with-param name="output_folder" select="$output_folder" />
			<xsl:with-param name="base_name" select="$base_name" />
			<xsl:with-param name="driver_name" select="$driver_name" />
			<xsl:with-param name="description" select="./@cart" />
		</xsl:call-template>
	</xsl:for-each>
</xsl:template>

<xsl:template name="check_files">
	<xsl:param name="output_folder" />
	<xsl:param name="base_name" />
	<xsl:param name="driver_name" />
	<xsl:param name="description" />

	<xsl:variable name="xml_file_name" select="concat($output_folder,'/',$base_name,'.xml')" />
	<xsl:variable name="png_size" select="document($xml_file_name)/output/result/dir/dir/file/@png_size" />
	<xsl:variable name="png_file_name" select="concat($output_folder,'/',$base_name,'/','snap','/',$driver_name,'/','final.png')" />
<p>
Result for <xsl:value-of select="$description" />:<br />
	<xsl:choose>
		<xsl:when test="$png_size">
			<xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="$png_file_name" /></xsl:attribute>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
<pre>
<xsl:value-of select="document($xml_file_name)/output/result/@stdout" />
</pre>
		</xsl:otherwise>
	</xsl:choose>
</p>
</xsl:template>

</xsl:stylesheet>
