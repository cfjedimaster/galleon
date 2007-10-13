<cfsetting enablecfoutputonly=true>
<!---
	Name         : syntax.cfm
	Author       : Raymond Camden 
	Created      : August 30, 2007
	Last Updated : 
	History      : 
	Purpose		 : Displays BBML Help
--->

<!--- Loads header --->
<cfmodule template="tags/layout.cfm" templatename="main" title="#application.settings.title# : Forum Syntax Rules">


<cfoutput>
<style>
p {
margin-top: 10px;
margin-bottom: 10px;
}
</style>
<p>
The following describes the BBML syntax rules allowed for this forum. BBML parsing (and this help text) come courtesy of <a href="http://www.depressedpress.com/Content/Development/ColdFusion/Extensions/DP_ParseBBML/Index.cfm">DP_ParseBBML</a>
by Depressed Press of Boston.
</p>

<p><a href="##General">General Notes</a> | <a href="##Simple">Simple Formatting</a> | <a href="##Links">Links and Images</a> | <a href="##Lists">Lists</a> | <a href="##Smilies">Smilies</a></i></p>

<p>This documentation pertains to the <a href="http://www.depressedpress.com/Content/Development/ColdFusion/Extensions/DP_ParseBBML/Index.cfm">DP_ParseBBML CFML Custom Tag</a>.</p>
<p>DP_ParseBBML translates a customized dialect of Bulletin Board Markup Language ("BBML", originally created for use in the popular <a href="http://www.ubbcentral.com/">Ultimate Bulletin Board&trade;</a>) in to browser-ready HTML markup.  BBML is easy to learn and use and gives end users safe access to many of HTML's formatting controls.</p>

<h2><a name="General">General Notes</a></h2>

	<p>BBML uses "tags" to define what formatting to apply to the text.  Tags are special codes surrounded by square brackets ("[]").  "Tag pairs" are used to define what formatting gets applied to what text.  In most cases there will be a "start tag" followed by the text to be formatting followed by the "end tag".  End tags are the same codes as the start tags prefixed by a forward slash ("/").  Here's a sample of the format:</p>
	<p><b>[tag]</b>Text to be formatted<b>[/tag]</b></p>
	<p>The following general rules apply to all conversions:</p>
	<ul><li>Only valid BBML code (as defined below) will be converted to HTML.</li>

		<li>Single Line Feed/Carriage Returns will be replaced with the HTML "break" tag (&lt;br&gt;).</li>
		<li>Double Line Feed/Carriage Returns will be replaced with the HTML "paragraph" tags (&lt;p&gt;&lt;/p&gt;).</li>
	</ul>
	<h3>Tag Nesting</h3>
	<p>BBML (like HTML) must be "nested" properly.  This is best explained with an example.  The first line is not valid BBML and will not be converted while the second line (with properly nested tags) is properly formatted:</p>

	<p><i>Bad</i>: <b>[b]</b>This is <b>[i]</b>some<b>[/b]</b> very fine<b>[/i]</b> sample text.</p>
	<p><i>Good</i>: <b>[b]</b>This is <b>[i]</b>some<b>[/i][/b] [i]</b>very fine<b>[/i]</b> sample text.</p>

	<p>BBML tags can be nested in this fashion as deeply as you like.  Also BBML tags not case sensitive.  In other words [B][/B] and [b][/b] are treated identically.</p>
	<p>Many BBML tags have both long, easy to remember versions and shorter, easier to type versions.  You cannot mix alternate begin and end tags however.  For example "[b]bold text[/bold]" is illegal; either "[b]bold text[/b]" or "[bold]bold text[/bold]" must be used.</p>

<h2><a name="Simple">Simple Formatting</a></h2>

	<p>The basic formatting tags are what you'll be using most often.  They general change the way that text is displayed on screen (bold, italic, etc) or add special formatting rules (indents, monospaced fonts, etc).</p>
	<h3>Simple Formatting</h3>
	<p>The following simple formatting tags are available.</p>
	<table cellpadding="5" cellspacing="0" border="1">
	 	<tr><td bgcolor="##eeeeee">Style</td><td bgcolor="##eeeeee">This BBML Code</td><td bgcolor="##eeeeee">Converts to</td></tr>
	 	<tr><td>Bold</td><td nowrap>[b][/b] or [bold][/bold]</td><td>&lt;b&gt;<b>bold</b>&lt;/b&gt;</td></tr>

	 	<tr><td>Italic</td><td nowrap>[i][/i] or [italic][/italic]</td><td>&lt;i&gt;<i>italic</i>&lt;/i&gt;</td></tr>
	 	<tr><td>Underlined</td><td nowrap>[u][/u] or [underline][/underline]</td><td>&lt;u&gt;<u>underlined</u>&lt;/u&gt;</td></tr>
	 	<tr><td>Strikethough</td><td nowrap>[s][/s] or [strikethrough][/strikethrough]</td><td>&lt;s&gt;<s>strikethrough</s>&lt;/s&gt;</td></tr>

	 	<tr><td>Superscript</td><td nowrap>[sup][/sup] or [superscript][/superscript]</td><td>&lt;sup&gt;<sup>superscript</sup>&lt;/sup&gt;</td></tr>
	 	<tr><td>Subscript</td><td nowrap>[sub][/sub] or [subscript][/subscript]</td><td>&lt;sub&gt;<sub>subscript</sub>&lt;/sub&gt;</td></tr>
	</table>
	<h3>Color and Size</h3>

	<p>Text color and size can be changed with the following tags:</p>
	<table cellpadding="5" cellspacing="0" border="1">
	 	<tr><td bgcolor="##eeeeee">Style</td><td bgcolor="##eeeeee">This BBML Code</td></tr>
	 	<tr><td valign="top">Color</td><td>[color=<i>color</i>][/color]<br><br>This tag will set the color of any text within it.  <i>Color</i> can be any named color (red, blue, yellow, etc) or a hexidecimal rgb value (for example "##ccffcc").</td></tr>

	 	<tr><td valign="top">Size</td><td>[size=<i>size</i>][/size]<br><br>This tag will set the size (font point size) of any text within it.  <i>Size</i> must be a number between 8 and 25.</td></tr>
	</table>
	<h3>Special Formatting</h3>
	<p>There are also four special types of simple formatting available:</p>

	<table cellpadding="5" cellspacing="0" border="1">
	 	<tr><td bgcolor="##eeeeee">Style</td><td bgcolor="##eeeeee">This BBML Code</td></tr>
	 	<tr><td valign="top">Quotation</td><td>[q][/q] or [quote][/quote]<br><br>This tag offsets and indents any text within it as per the HTML &lt;blockquote&gt;&lt;/blockquote&gt; tag.</td></tr>
	 	<tr><td valign="top">Code</td><td>[code][/code]<br><br>Used around blocks of programming code (such as HTML, CFML, JavaScript, etc).</td></tr>

	 	<tr><td valign="top">SQL</td><td>[sql][/sql]<br><br>Used around blocks of SQL code, this tag will bold all words reserved in the SQL92 and SQL99 standards such as "SELECT" and "DROP".</td></tr>
	 	<tr><td valign="top">Preformated</td><td>[pre][/pre] or [preformatted][/preformatted]<br><br>Text placed within this tag will be displayed in a monospaced font and all spaces will be honored as per the HTML &lt;pre&gt;&lt;/pre&gt; tag.</td></tr>
	</table>
	<h3>Examples</h3>

	<p>All simple formatting tags can be used within links, lists, and each other (as long as proper nesting rules are honored).  This means that you can have very complex nestings and combinations of formatting.  Here are some examples of simple formatting:</p>
	<table cellpadding="5" cellspacing="0" border="1">
	 	<tr><td bgcolor="##eeeeee">BBML Code</td><td bgcolor="##eeeeee">Result</td></tr>
		<tr><td>This is [b]bold[/b] and this is [i]italic[/i].</td><td>This is <b>bold</b> and this is <i>italic</i>.</td></tr>

		<tr><td>This [b]is a [i][sub]little[/sub] [u]more[/u][/i] complicated[/b]</td><td>This <b>is a <i><sub>little</sub> <u>more</u></i> complicated</b></td></tr>
		<tr><td>This [i][s]is[/s] [u]even more complicated[/u][/i], [sup]but still perfectly [b]legal[/b][/sup].</td><td>This <i><s>is</s> <u>even more complicated</u></i>, <sup>but still perfectly <b>legal</b></sup>.</td></tr>

		<tr><td>This [color=blue]blue[/color] and this is [color=##FF0000]Red[/color].</td><td>This <span style="color: blue">blue</span> and this is <span style="color: ##FF0000">Red</span>.</td></tr>
		<tr><td>[size=15]This text[/size] is larger than [size=8]this text[/size] but not as large as [size=25]this text[/size].</td><td><span style="font-size: 15pt">This text</span> is larger than <span style="font-size: 8pt">this text</span> but not as large as <span style="font-size: 25pt">this text</span>.</td></tr>

	</table>

<h2><a name="Links">Links and Images</a></h2>

	<p>There are two kinds of links available in BBML: "normal" links and email links.  A normal link is most often used to reference a web page or FTP site but any valid URL (a web address such as "http://www.depressedpress.com") can be used.  An email link is specifically and only used for email address.</p>
	<h3>Links</h3>

	<p>Their are two ways create a normal link, simple and complex:</p>
	<p><i>Simple</i>: <b>[link]</b>URL<b>[/link]</b> (or <b>[url]</b>URL<b>[/url]</b>)</p>
	<p><i>Complex</i>: <b>[link=</b>URL<b>]</b>Link Label<b>[/link]</b> (or <b>[url=</b>URL<b>]</b>Link Label<b>[/url]</b>)</p>

	<p>In the same way there are two ways create an email link:</p>
	<p><i>Simple</i>: <b>[email]</b>address<b>[/email]</b></p>
	<p><i>Complex</i>: <b>[email=</b>address<b>]</b>Label<b>[/email]</b></p>

	<p>In both cases the text between the tags is the visible, clickable part of the link.</p>
	<h3>Images</h3>
	<p>Adding images is done with the [img][/img] (or, alternately, with the equivalent [image][/image] tag).  You must wrap the full address of the image (for example "http://www.mysite.com/image.jpg") in the tag like so:</p>
	<p><b>[img]</b>image<b>[/img]</b></p>
	<h3>Wrapping and Examples</h3>

	<p>The image tag can be wrapped in the [link] and [email] tags to make clickable images.  However the [img] can not have any tags within it.  In addition the [link] and [email] tags cannot wrap each other (although they may wrap basic formatting tags).</p>
	<p>Here are some examples of links and images:</p>
	<table cellpadding="5" cellspacing="0" border="1">
	 	<tr><td bgcolor="##eeeeee">BBML Code</td><td bgcolor="##eeeeee">Result</td></tr>
		<tr><td>[link]http://www.yahoo.com[/link]</td><td><a href="http://www.yahoo.com">http://www.yahoo.com</a></td></tr>
		<tr><td>[url=http://www.yahoo.com]Yahoo![/url]</td><td><a href="http://www.yahoo.com">Yahoo!</a></td></tr>

		<tr><td>[b][url=http://www.yahoo.com]Yahoo![/url][/b]</td><td><b><a href="http://www.yahoo.com">Yahoo!</a></b></td></tr>
		<tr><td>[email]bill.gates@microsoft.com[/email]</td><td><a href="mailto:bill.gates@microsoft.com">bill.gates@microsoft.com</a></td></tr>
		<tr><td>[email=ppan@neverland.com]Peter Pan[/email]</td><td><a href="mailto:ppan@neverland.com">Peter Pan</a></td></tr>
		<tr><td>[img]#application.settings.rooturl#images/galleon.gif[/img]</td><td><img src="#application.settings.rooturl#images/galleon.gif"></td></tr>
		<tr><td>[link=http://galleon.riaforge.org][img]#application.settings.rooturl#images/galleon.gif[/img][/link]</td><td><a href="http://galleon.riaforge.org"><img src="#application.settings.rooturl#images/galleon.gif"></a></td></tr>

		<tr><td></td><td></td></tr>
	</table>

<h2><a name="Lists">Lists</a></h2>
	<p>BBML lists come in two basic forms: unordered (or bulleted) lists and ordered (numbered or alphabetized) lists.  In both cases the same basic formatting applies.  The list tags contain any number of "item" tags ("[*]").  An item tag is placed before each item in the list and does not require and end tag.  Here are the types of lists followed by the HTML that they produce:</p>

	<table cellpadding="5" cellspacing="0" border="1">
		<tr><td bgcolor="##eeeeee">List Type</td>
			<td bgcolor="##eeeeee">BBML Code</td>
			<td bgcolor="##eeeeee">Result</td>
		</tr>
		<tr><td valign="top">Unordered List</td>
			<td><b>[list]</b><br><b>[*]</b>Item One<br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ul><li>Item One</li><li>Item Two</li><li>Item Three</li></ul></td>
		</tr>
		<tr><td valign="top">Numbered List</td>
			<td><b>[list=1]</b><br><b>[*]</b>Item One<br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ol type="1"><li>Item One</li><li>Item Two</li><li>Item Three</li></ol></td>
		</tr>
		<tr><td valign="top">Numbered List<br>(Small Roman Numerals)</td>
			<td><b>[list=i]</b><br><b>[*]</b>Item One<br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ol type="i"><li>Item One</li><li>Item Two</li><li>Item Three</li></ol></td>
		</tr>
		<tr><td valign="top">Numbered List<br>(Large Roman Numerals)</td>
			<td><b>[list=I]</b><br><b>[*]</b>Item One<br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ol type="I"><li>Item One</li><li>Item Two</li><li>Item Three</li></ol></td>
		</tr>
		<tr><td valign="top">Alphabetized List<br>(Lowercase)</td>
			<td><b>[list=a]</b><br><b>[*]</b>Item One<br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ol type="a"><li>Item One</li><li>Item Two</li><li>Item Three</li></ol></td>
		</tr>
		<tr><td valign="top">Alphabetized List<br>(Uppercase)</td>
			<td><b>[list=A]</b><br><b>[*]</b>Item One<br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ol type="A"><li>Item One</li><li>Item Two</li><li>Item Three</li></ol></td>
		</tr>
	</table>
	<p>A list must have at least one item tag ("[*]") in it to be valid.  In addition the there can be no text between the beginning list tag and the first item tag ("[list][*][/list]" is correct while "[list]MyList [*][/list]" will fail).</p>
	<p>Lists can be nested together as deeply as you like, but each nested list must be a list item of the outer list.  Here's an example of nesting:</p>
	<table cellpadding="5" cellspacing="0" border="1">

		<tr><td bgcolor="##eeeeee">List</td>
			<td bgcolor="##eeeeee">BBML Code</td>
			<td bgcolor="##eeeeee">Result</td>
		</tr>
		<tr><td valign="top">Unordered List</td>
			<td><b>[list]</b><br><b>[*]</b>Item One<br>&nbsp; <b>[list=1]</b><br>&nbsp; <b>[*]</b>Item One<br>&nbsp; <b>[*]</b>Item Two<br>&nbsp; <b>[list=I]</b><br>&nbsp;&nbsp;<b>[*]</b>Item One<br>&nbsp; &nbsp;<b>[*]</b>Item Two<br>&nbsp; &nbsp;<b>[*]</b>Item Three<br>&nbsp; &nbsp; <b>[list=i]</b><br>&nbsp; &nbsp; <b>[*]</b>Item One<br>&nbsp; &nbsp; <b>[*]</b>Item Two<br>&nbsp; &nbsp; <b>[*]</b>Item Three<br>&nbsp; &nbsp; <b>[/list]</b><br>&nbsp; &nbsp;<b>[/list]</b><br>&nbsp; <b>[*]</b>Item Three<br>&nbsp; <b>[/list]</b><br><b>[*]</b>Item Two<br><b>[*]</b>Item Three<br><b>[/list]</b></td>

			<td><ul><li>Item One   <ol type="1"><li>Item One   </li><li>Item Two   <ol type="I"><li>Item One    </li><li>Item Two    </li><li>Item Three     <ol type="i"><li>Item One     </li><li>Item Two     </li><li>Item Three     </li></ol>    </li></ol>   </li><li>Item Three   </li></ol> </li><li>Item Two </li><li>Item Three </li></ul></td>

		</tr>
	</table>
	<p>List items may use any formatting or link tags that you wish and may include images.  Lists themselves however may only be contained in other list tags.</p>

<h2><a name="Smilies">Smilies</a></h2>

	<p>Smilies, also know as "emoticons" are expressive codes appended to text.  They are generally seen as small picture turned 90 degrees to the right so that ":^)" is a "smiling face".  There are many different kinds of smilies and some can become very, very elaborate.  DP_ParseBBML can convert a subset of these smilies codes into graphical images.  Most of the smilies have at least one alternative way to type it and some have several.  For our purposes all smilies are made up of three characters however (generally "eyes", "nose" and "mouth").</p>
	<p>Here is a list of the smilies supported by DP_ParseBBML and the graphic that will replace it:</p>
	<table cellpadding="5" cellspacing="0" border="0">
		<tr><td bgcolor="##eeeeee">Meaning</td><td bgcolor="##eeeeee">What to Type</td><td bgcolor="##eeeeee">Default Set</td></tr>
		<tr><td>Happy</td><td><b>:^)</b> or <b>:')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Happy.gif" alt="Happy" border="0"></td></tr>

		<tr><td>Very Happy (Laughing)</td><td><b>:^D</b> or <b>:'D</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/VeryHappy.gif" alt="Very Happy" border="0"></td></tr>
		<tr><td>Apathetic or Neutral</td><td><b>:^|</b> or <b>:'|</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Neutral.gif" alt="Neutral" border="0"></td></tr>
		<tr><td>Sad</td><td><b>:^(</b> or <b>:'(</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Sad.gif" alt="Sad" border="0"></td></tr>

		<tr><td>Very Sad (Crying)</td><td><b>L^(</b> or <b>L'(</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/VerySad.gif" alt="Crying" border="0"></td></tr>
		<tr><td>Mad</td><td><b>&gt;^(</b> or <b>&gt;'(</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Mad.gif" alt="Mad" border="0"></td></tr>
		<tr><td>Very Mad</td><td><b>&gt;^X</b> or <b>&gt;'X</b> or <b>&gt;^x</b> or <b>&gt;'x</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/VeryMad.gif" alt="Very Mad" border="0"></td></tr>

		<tr><td>Wink</td><td><b>;^)</b> or <b>;')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Wink.gif" alt="Wink" border="0"></td></tr>
		<tr><td>Wincing</td><td><b>;^|</b> or <b>;'|</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Wincing.gif" alt="Wincing" border="0"></td></tr>
		<tr><td>Shouting</td><td><b>:^O</b> or <b>:'O</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Shouting.gif" alt="Shouting" border="0"></td></tr>

		<tr><td>Interested</td><td><b>=^)</b> or <b>=')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Interested.gif" alt="Interested" border="0"></td></tr>
		<tr><td>Thinking Hard</td><td><b>;^`</b> or <b>;'`</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/ThinkingHard.gif" alt="Thinking Hard" border="0"></td></tr>
		<tr><td>Confused</td><td><b>;^d</b> or <b>;'d</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Confused.gif" alt="Confused" border="0"></td></tr>

		<tr><td>Slightly Shocked</td><td><b>=^~</b> or <b>='~</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/SlightlyShocked.gif" alt="Slightly Shocked" border="0"></td></tr>
		<tr><td>Shocked or Suprised</td><td><b>=^o</b> or <b>='o</b> or <b>=^O</b> or <b>='O</b> or <b>=^0</b> or <b>='0</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Shocked.gif" alt="Shocked" border="0"></td></tr>

		<tr><td>Kiss (Puckering Up)</td><td><b>=^*</b> or <b>='*</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Kiss.gif" alt="Kiss" border="0"></td></tr>
		<tr><td>Cool</td><td><b>8^)</b> or <b>8')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Cool.gif" alt="Cool" border="0"></td></tr>
		<tr><td>Drooling</td><td><b>:^}</b> or <b>:'}</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Drooling.gif" alt="Drooling" border="0"></td></tr>

		<tr><td>Sticking out tounge</td><td><b>:^b</b> or <b>:'b</b> or <b>:^p</b> or <b>:'p</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/StickingOutTounge.gif" alt="Sticking out Tongue" border="0"></td></tr>
		<tr><td>Yawning</td><td><b>{^o</b> or <b>{'o</b> or <b>{^O</b> or <b>{'O</b> or <b>{^0</b> or <b>{'0</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Yawning.gif" alt="Yawning" border="0"></td></tr>

		<tr><td>Sleeping</td><td><b>{^)</b> or <b>{')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Sleeping.gif" alt="Sleeping" border="0"></td></tr>
		<tr><td>Embarassed</td><td><b>##^)</b> or <b>##')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Embarassed.gif" alt="Embarassed" border="0"></td></tr>
		<tr><td>Crazy (Drunk, Blotto)</td><td><b>%^)</b> or <b>%')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Crazy.gif" alt="Crazy" border="0"></td></tr>

		<tr><td>Evil</td><td><b>B^&gt;</b> or <b>B'&gt;</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Evil.gif" alt="Evil" border="0"></td></tr>
		<tr><td>Angelic</td><td><b>O^)</b> or <b>O')</b> or <b>o^)</b> or <b>o')</b> or <b>0^)</b> or <b>0')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Angelic.gif" alt="Angelic" border="0"></td></tr>

		<tr><td>Question Mark</td><td><b>?^)</b> or <b>?')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Question.gif" alt="Question Mark" border="0"></td></tr>
		<tr><td>Exclmation Point</td><td><b>!^)</b> or <b>!')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Exclamation.gif" alt="Exclamation Point" border="0"></td></tr>
		<tr><td>Idea (Light Bulb)</td><td><b>$^)</b> or <b>$')</b></td><td align="center"><img src="#application.settings.rooturl#images/Smilies/Default/Idea.gif" alt="Idea" border="0"></td></tr>

	</table>
</cfoutput>
	
</cfmodule>

<cfsetting enablecfoutputonly=false>

