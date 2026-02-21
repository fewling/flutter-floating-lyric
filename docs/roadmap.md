# Roadmap

Rough Idea:

1. Add support of translated sub-LRCs
   1. Support manual creation + edit
   2. Support automatic creation + AI generated translation
2. AI generated translation:
   1. First use Firebase AI kit for faster deployment
   2. Support user added API keys to make requests to certain AI providers
3. (Optional) add validation logics on the LRC content
4. Implement AI rate limiter function
   1. Records users’ request rates on cloud
   2. Reject request if exceeds the limit

## Translated sub-LRCs

1. DB schema update: add a new box for translated sub-LRCs, which is linked to the original LRC
2. UI update: add a new section for translated sub-LRCs in the LRC editor page, which allows users to add, edit and delete translated sub-LRCs
3. Logic update: when displaying lyrics, check:
   - the preferred translation language of the user
   - if there is a translated sub-LRC in that language
   - if yes, display the translated sub-LRC alongside the original LRC on the overlay window (display format to be determined)
