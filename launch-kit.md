# Launch kit

Everything below is ready to copy. Replace `https://chunkbook.pages.dev` with the live address
before posting anywhere.

---

## 1. The 15-second video

This matters more than any of the text. Nobody opens a link; everybody watches a
silent autoplaying clip. Record the screen at 1280×800, no cursor trails, no
music, no titles. Export as MP4 **and** GIF — Telegram and Reddit prefer MP4,
some places still want GIF.

Use Harrison's or any book with real bookmarks. The whole point is that it is
obviously a real book, not a demo file.

| Time | What's on screen | Why |
|---|---|---|
| 0–2s | A Finder window. Drag `harrison.pdf` — the size badge reading ~180 MB visible — onto the drop zone. | Establishes stakes in two seconds: this is a huge real book. |
| 2–4s | The progress bar sweeping, page counter climbing to 2,443. | Proves it's actually reading, not faking. |
| 4–7s | The three notices appearing: printed-page offset 43, contents pages skipped, structure chooser listing **Parts 6 · Sections 47 · Chapters 312** with BEST FIT on chapters. | This is the moment that earns the slogan. Let it breathe — it's the longest hold in the clip. |
| 7–10s | Scroll the parts list. Card after card with `PART 4 › SECTION 1` above real chapter names, all tags blue. | Shows the output is labelled, not numbered mush. |
| 10–12s | Click **Download all as ZIP**. Finder shows the folder unpacking — dozens of files named `007-part-6-section-4-231-heart-failure.md`. | The payoff. Filenames do the talking. |
| 12–15s | Open one file. The label block visible at the top: title, path, pages, cut_basis. Hold. | Ends on the thing nobody else does. |

**Do not** add a voiceover, a logo animation, or text overlays. The deadpan is
the brand. If you must caption it, one line at the end: *no upload, no account,
one HTML file.*

---

## 2. Show HN

Post on a weekday morning, US Eastern. Then stay at your desk for two hours —
the first two hours decide everything, and answering comments quickly matters
more than the post itself.

**Title** (HN titles must be plain — no hype, no emoji):

```
Show HN: Chunkbook – splits a book into labelled chunks at real chapter boundaries
```

**First comment**, posted by you immediately after submitting:

```
I kept feeding textbooks to LLMs and kept hitting the same two problems:
naive chunkers cut mid-sentence, and every chunk arrives with no idea where
it sits in the book.

This does three things differently:

- It cuts at the book's own structure. PDF bookmarks when they exist;
  inferred from type size and numbering when they don't. If a section is
  still too big it descends into the headings inside it before falling back
  to cutting for length.
- Every part is labelled with its full path — PART 6 › SECTION 4 › 231 Heart
  Failure — plus page range, token estimate, and which part comes before and
  after. The filename carries it too.
- It works out the offset between printed page numbers and PDF page numbers
  by reading the running heads, so the ranges match the book's own contents
  page. On Harrison's it found a 43-page offset with 91% agreement.

It also tells you when it's guessing. If a book has no contents list it says
so and recommends cutting by hand instead of quietly producing garbage.

No OCR, and I'm not adding it — a scan is a picture of a book, and doing OCR
badly is worse than not doing it. Token counts are estimates from character
mix, ±15%.

One HTML file, runs entirely in the browser, nothing uploaded. Source is
right there; there's nothing else to it.

https://chunkbook.pages.dev
```

**Expect these questions.** Have answers ready:

- *Why not just use a recursive text splitter / LangChain?* Because those split
  on characters and separators, not on the document's structure. A chapter
  boundary is semantic information the file already contains and they throw it
  away.
- *Why no OCR?* Answered in the post. Hold the line; the honesty is the point.
- *Why not a server?* Because a 200 MB medical textbook is not something people
  want to upload, and a static file costs nothing to run forever.
- *Token estimates are wrong.* Agreed and stated. Show the ±15% note.

---

## 3. Reddit

**Do not post an announcement first.** Spend a week answering the question where
it's already being asked. In r/ClaudeAI, r/LocalLLaMA, r/ChatGPTPro and
r/OpenAI, somebody asks a version of "how do I give a whole book to the model"
several times a week. Search those subs for:

```
split book · large PDF · context limit · chunk textbook · whole book
```

Reply properly — explain the chapter-boundary point in your own words — and put
the link at the end as a footnote, not a headline. Ten such replies beat one
announcement post, and they don't get removed.

Once you have a few of those and someone has said it helped, then post
standalone to r/LocalLLaMA with the video:

**Title:**

```
I got tired of chunkers cutting mid-sentence, so I made one that cuts at chapters
```

**Body:** the same three bullets from the HN comment, shorter, video at the top.

---

## 4. Persian channels

Your easiest early win. Less competition, and the problem bites harder because
so much material is scanned or badly typeset.

**تلگرام / لینکدین:**

```
کتاب ۹۰۰ صفحه‌ای در یک چت جا نمی‌شود. ابزارهای موجود هم کورکورانه هر
۵۰۰۰ کاراکتر می‌برند و وسط جمله را نصف می‌کنند.

این ابزار سر فصل‌های واقعی خود کتاب می‌برد — از روی فهرست داخلی PDF، و
اگر نداشت از روی اندازه‌ی قلم و شماره‌گذاری. روی هر تکه می‌نویسد کجای
کتاب است: بخش، فصل، محدوده‌ی صفحه، و تکه‌های قبل و بعد.

اختلاف شماره‌ی صفحه‌ی چاپی با صفحه‌ی PDF را هم خودش پیدا می‌کند — روی
هریسون ۴۳ صفحه بود.

عنوان‌های فارسی، عربی، روسی، چینی و چند زبان دیگر را می‌شناسد.

رایگان، بدون ثبت‌نام، و هیچ فایلی آپلود نمی‌شود — همه‌چیز داخل مرورگر
خودتان اجرا می‌شود.

https://chunkbook.pages.dev
```

Post the video with it. Same rule as Reddit: answering an existing question
beats an announcement.

---

## 5. What to watch, and what "working" looks like

Do not measure day-one traffic. Most tools like this get a couple of hundred
visits and three people who stay — and that is not failure.

The number that matters is **how many people come back in week two**. Ten
regular users who send you reports is a better position than a thousand who
looked once, because the reports tell you what to build next.

The first real problem report will arrive with the full diagnostic block —
page count, outline source, how many parts were forced by length. That is
usually enough to find the bug without asking a single follow-up question.
