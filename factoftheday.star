load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")
load("encoding/json.star", "json")

def main(config):
	API_Key_Ninjas = config.get("api_key")
	FACT_OF_DAY_URI = "https://api.api-ninjas.com/v1/facts"

	fact_of_day_cached = cache.get("fact_of_the_day")
	if fact_of_day_cached != None:
		print("pulling from cache")
		response = json.decode(fact_of_day_cached)
	else:
		print("pulling fresh")
		response = http.get(FACT_OF_DAY_URI, headers={"X-Api-Key": API_Key_Ninjas})
		if(response.status_code != 200):
			fail("Request failed with status %d", response.status_code)
		response = response.json()
		cache.set("fact_of_the_day", json.encode(response), ttl_seconds = 43200)

	fact = response[0]["fact"]

	fact_word_count = len(fact.split())

	#word_font = "CG-pixel-3x5-mono"
	#word_font = "tb-8"
	word_font = "5x8"

	return render.Root(
		delay = 60,
		child = render.Marquee(
			height = 32 + int((fact_word_count * 1.5)),
			scroll_direction = "vertical",
			offset_start = 34,
			offset_end = 33,
			child = render.Column(
				cross_align = "center",
				children = [
					render.Padding(
						child = render.WrappedText("Fact of the Day", font="Dina_r400-6", color="#afa"),
						pad = (0,0,0,6)
					),
					render.WrappedText(
						width = 64,
						linespacing = -1,
		 				content = fact,
						color="#cfcfcf"
		 			)
				]
			)
		)
	)

