//General section
GLOBAL_LIST_INIT(localization, list())

/datum/letter
	var/letter = ""			//weird letter
	var/chat = ""			//letter in chat
	var/browser = ""		//letter in browser
	var/log = ""			//letter for logs
	var/temp = ""			//temporatory letter for filled input windows
							//!!!temp must be unique for every letter!!!

	autofix_proper
		letter = "\proper"
		chat = ""
		browser = ""
		log = ""
		temp = ""

	autofix_improper
		letter = "\improper"
		chat = ""
		browser = ""
		log = ""
		temp = ""

	cyrillic_ya
		letter = "�"
		chat = "&#255;"
		browser = "&#1103;"
		log = "�"
		temp = "�"

/proc/sanitize_local(var/text, var/mode = SANITIZE_CHAT)
	if(!istext(text))
		return text
	for(var/datum/letter/L in GLOB.localization)
		switch(mode)
			if(SANITIZE_CHAT)		//only basic input goes to chat
				text = replace_characters(text, list(L.letter=L.chat, L.temp=L.chat))

			if(SANITIZE_BROWSER)	//browser takes everything
				text = replace_characters(text, list(L.letter=L.browser, L.temp=L.browser, L.chat=L.browser))

			if(SANITIZE_LOG)		//logs can get raw or prepared text
				text = replace_characters(text, list(L.letter=L.log, L.chat=L.log))

			if(SANITIZE_TEMP)		//same for input windows
				text = replace_characters(text, list(L.letter=L.temp, L.chat=L.temp))
	return text

/proc/replace_characters(var/t,var/list/repl_chars)
	for(var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t

/*
	Both encode and decode can break special symbol codes, so we need to replace them.
	Text letters always tuning into chat mode, and browser sanitization should be before every browser() call.
	I dunno, should every call be replaced, because maybe there some calls that isn`t used with users input.
*/

/proc/lhtml_encode(var/text, var/mode = SANITIZE_CHAT)
	text = sanitize_local(text, SANITIZE_TEMP)
	text = html_encode(text)
	text = sanitize_local(text, mode)
	return text

/proc/lhtml_decode(var/text, var/mode = SANITIZE_CHAT)
	text = sanitize_local(text, SANITIZE_TEMP)
	text = html_decode(text)
	text = sanitize_local(text, mode)
	return text

/proc/upperrustext(text as text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if(a > 223)
			t += ascii2text(a - 32)
		else if(a == 184)
			t += ascii2text(168)
		else t += ascii2text(a)
	t = replacetext(t,"�","�")
	t = replacetext(t,"&#255;","�")
	t = replacetext(t, "�", "�")
	return t


/proc/lowerrustext(text as text)
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if(a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if(a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	t = replacetext(t,"�","&#255;")
	return t

//UTF section of l10n. Used in /"tg"/Chat and /tg/UI.
GLOBAL_LIST_INIT(c1251_to_utf_table, list(
	"�" = "0410", "�" = "0430",
	"�" = "0411", "�" = "0431",
	"�" = "0412", "�" = "0432",
	"�" = "0413", "�" = "0433",
	"�" = "0414", "�" = "0434",
	"�" = "0415", "�" = "0435",
	"�" = "0416", "�" = "0436",
	"�" = "0417", "�" = "0437",
	"�" = "0418", "�" = "0438",
	"�" = "0419", "�" = "0439",
	"�" = "041a", "�" = "043a",
	"�" = "041b", "�" = "043b",
	"�" = "041c", "�" = "043c",
	"�" = "041d", "�" = "043d",
	"�" = "041e", "�" = "043e",
	"�" = "041f", "�" = "043f",
	"�" = "0420", "�" = "0440",
	"�" = "0421", "�" = "0441",
	"�" = "0422", "�" = "0442",
	"�" = "0423", "�" = "0443",
	"�" = "0424", "�" = "0444",
	"�" = "0425", "�" = "0445",
	"�" = "0426", "�" = "0446",
	"�" = "0427", "�" = "0447",
	"�" = "0428", "�" = "0448",
	"�" = "0429", "�" = "0449",
	"�" = "042a", "�" = "044a",
	"�" = "042b", "�" = "044b",
	"�" = "042c", "�" = "044c",
	"�" = "042d", "�" = "044d",
	"�" = "042e", "�" = "044e",
	"�" = "042f", "�" = "044f",

	"�" = "0401", "�" = "0451",

	"�" = "0403", "�" = "0404",
	"�" = "0407", "�" = "0453",
	"�" = "0454", "�" = "0457",
	"�" = "0490", "�" = "0491",
	"�" = "2022", "�" = "2013",
	"�" = "2014", "�" = "2116"
))

GLOBAL_LIST_INIT(j1251_to_utf_table, list(
	"c0" = "0410", "e0" = "0430",
	"c1" = "0411", "e1" = "0431",
	"c2" = "0412", "e2" = "0432",
	"c3" = "0413", "e3" = "0433",
	"c4" = "0414", "e4" = "0434",
	"c5" = "0415", "e5" = "0435",
	"c6" = "0416", "e6" = "0436",
	"c7" = "0417", "e7" = "0437",
	"c8" = "0418", "e8" = "0438",
	"c9" = "0419", "e9" = "0439",
	"ca" = "041a", "ea" = "043a",
	"cb" = "041b", "eb" = "043b",
	"cc" = "041c", "ec" = "043c",
	"cd" = "041d", "ed" = "043d",
	"ce" = "041e", "ee" = "043e",
	"cf" = "041f", "ef" = "043f",
	"d0" = "0420", "f0" = "0440",
	"d1" = "0421", "f1" = "0441",
	"d2" = "0422", "f2" = "0442",
	"d3" = "0423", "f3" = "0443",
	"d4" = "0424", "f4" = "0444",
	"d5" = "0425", "f5" = "0445",
	"d6" = "0426", "f6" = "0446",
	"d7" = "0427", "f7" = "0447",
	"d8" = "0428", "f8" = "0448",
	"d9" = "0429", "f9" = "0449",
	"da" = "042a", "fa" = "044a",
	"db" = "042b", "fb" = "044b",
	"dc" = "042c", "fc" = "044c",
	"dd" = "042d", "fd" = "044d",
	"de" = "042e", "fe" = "044e",
	"df" = "042f", "ff" = "044f",

	"a8" = "0401", "b8" = "0451",

	"81" = "0403", "83" = "0453",
	"95" = "2022", "96" = "2013", "97" = "2014",
	"a5" = "0490", "aa" = "0404", "af" = "0407",
	"b4" = "0491", "ba" = "0454", "b9" = "2116", "bf" = "0457"
))

/proc/extA2U(t)
	if(!t)
		return

	t = replacetext(t, "&#255;", "\\u044f")
	t = replacetext(t, "&#1103;", "\\u044f")

	if(DM_VERSION < 511)
		for(var/s in GLOB.j1251_to_utf_table)
			t = replacetext(t, "\\x[s]", "\\u[GLOB.j1251_to_utf_table[s]]")
	else
		for(var/s in GLOB.j1251_to_utf_table)
			t = replacetext(t, "\\u00[s]", "\\u[GLOB.j1251_to_utf_table[s]]")
	return t

/proc/convert1251_to_utf(t)
	if(!t)
		return

	t = replacetext(t, "&#255;", "&#x044f")
	t = replacetext(t, "&#1103;", "&#x044f")

	for(var/s in GLOB.c1251_to_utf_table)
		t = replacetext(t, s, "&#x[GLOB.c1251_to_utf_table[s]];")
	return t
