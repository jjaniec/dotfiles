#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import asyncio
import aiohttp
import os
import traceback
from pprint import pprint

API_DOMAIN = "https://api.thecatapi.com"
SEARCH_URI = "/v1/images/search"

CATS_API_KEY = os.getenv("CATS_API_KEY", None)

REQUEST_HEADERS = {
	'x-api-key': CATS_API_KEY
}
REQUEST_PAYLOAD = {}
CAT_BREED_IDS = [
	'cypr',
	'dons',
	'emau'
]

loop = asyncio.get_event_loop()


class InvalidAPIKey(Exception):
	pass


async def fetch(session: object, url: str) -> object:
	print(f"Fetching {url}")
	async with session.get(
		url,
		data=REQUEST_PAYLOAD,
		headers=REQUEST_HEADERS
	) as resp:
		print(f"{url}: {resp.status}")
		return await resp.json()


async def main() -> object:
	try:
		if CATS_API_KEY is None:
			raise InvalidAPIKey
		async with aiohttp.ClientSession() as session:
			requests = asyncio.gather(
				*map(lambda breed_id: fetch(
					session, f"{API_DOMAIN}{SEARCH_URI}?breed_ids={breed_id}"),
					CAT_BREED_IDS
				)
			)
			responses = await requests
			pprint(list(map(lambda r: r[0]['url'], responses)))
	except InvalidAPIKey as err:
		print("A valid API Key must be provided!")
		traceback.print_exc()
		return (1)
	return(0)

if __name__ == "__main__":
	loop.run_until_complete(main())
	loop.close()
