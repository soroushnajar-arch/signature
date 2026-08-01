# Chunkbook

Splits a long PDF book into labelled parts sized to fit an LLM's context window —
cut at the book's own chapter boundaries, or at page ranges you set by hand.

Live at **https://chunkbook.pages.dev**

By Soroush Najjar. MIT licence — use it, change it, ship it; just keep the notice.

Everything runs in the browser. No server, no build step, nothing uploaded.

```
chunkbook/
├── index.html      landing page
├── app.html        the splitter
├── setup.sh        downloads the libraries (macOS / Linux)
├── setup.ps1       downloads the libraries (Windows)
├── README.md       this file
└── lib/            four .js files, about 2 MB — must be committed
```

---

## What it does

- **Cuts at real structure.** PDF bookmarks when the file has them; headings
  inferred from type size and numbering when it doesn't. If a section is still
  too long it descends into the headings *inside* it before falling back to
  cutting for length.
- **Labels every part** with its full path — `PART 6 › SECTION 4 › 231 Heart
  Failure` — plus page range, token estimate, and the parts either side. The
  filename carries a compact version of the same chain.
- **Reconciles page numbers.** Works out the offset between the printed page
  numbers and the PDF's own numbering by reading the running heads, so ranges
  match the book's contents page. On Harrison's it finds a 43-page offset.
- **Skips contents and index pages**, detected by shape rather than by keyword —
  dot leaders, short lines ending in rising page numbers, or alphabetically
  ordered entries.
- **Says when it is guessing.** A book with no contents list gets a clear warning
  and a recommendation to cut by hand instead.
- **Any language.** Heading detection covers Latin, Persian, Arabic, Cyrillic,
  CJK and Korean scripts. Manual ranges never read the text at all.

---

## 1. Setup

The libraries are not committed as source; fetch them once:

**macOS / Linux**

```bash
bash setup.sh
```

**Windows**

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

This downloads four files into `lib/` and checks each is a real library rather
than an error page saved under the right name. By hand, keeping the filenames:

| File | Source |
|---|---|
| `pdf.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js` |
| `pdf.worker.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js` |
| `jszip.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js` |
| `pdf-lib.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/pdf-lib/1.17.1/pdf-lib.min.js` |

Keep these versions. pdf.js 4 and later moved to ES modules and will not work
with this code.

---

## 2. Run it locally

**Do not open `app.html` by double-clicking.** Browsers block web workers on
`file://` URLs and PDF reading will fail. Serve the folder over HTTP:

```bash
cd chunkbook
python3 -m http.server 8000
```

Then open <http://localhost:8000>. If setup is incomplete or the file was opened
the wrong way, the page says so and prints the command to fix it.

---

## 3. Check it works

Use a book you know well — ideally one with proper bookmarks and a second
without.

**Reading the file**

- [ ] Page count matches the real page count.
- [ ] "Outline entries" says `bookmarks` for a PDF that has them, `detected`
      otherwise.
- [ ] Detected structure lists chapter titles you recognise. Spot-check three
      page numbers against the book.
- [ ] If the printed numbering differs from the PDF's, the offset notice appears
      with a confidence figure above ~80%.
- [ ] Contents and index pages are flagged, and the run covers roughly the right
      span rather than clipping to two or three pages.

**Cutting**

- [ ] Parts appear on their own as soon as the file loads.
- [ ] The structure chooser lists the book's real units — Parts, Sections,
      Chapters — with counts, and marks one **best fit**.
- [ ] The advice box under the size control either confirms nothing exceeded
      three pieces, or names the worst section and offers a maximum that fixes it.
- [ ] Preview a part: the text starts at that chapter, not mid-way through the
      previous one.
- [ ] Set the maximum low, say 2000, and rebuild. Oversized sections split into
      `(1/3)`, `(2/3)`, `(3/3)` at paragraph breaks, never mid-sentence.
- [ ] With overlap above zero, part 2 opens with `…` followed by a **complete
      sentence**, not a fragment.
- [ ] The coverage bar is striped blue, not solid black, and its scale shows
      about ten round numbers.

**Manual ranges**

- [ ] Adding a range shows the right token estimate immediately.
- [ ] An out-of-bounds page turns the row red and names the valid range.
- [ ] *Split evenly into 10* covers the whole bar; deleting a middle range leaves
      a grey gap; *Add uncovered pages* fills it; overlapping ranges show gold.
- [ ] *Copy outline parts here* fills the table with editable chapters.

**Export**

- [ ] ZIP contains numbered `.md` files, `_index.md` and `manifest.json`.
- [ ] A chunk file's header carries the full path, both page numberings, and
      `cut_basis`.
- [ ] PDF page slices open and contain exactly the pages their name claims.
- [ ] `manifest.json` parses as valid JSON.

**Edge cases**

- [ ] Scanned PDF with no text layer → red notice, no OCR promised, switches to
      manual mode and PDF export. Must not produce empty parts silently.
- [ ] One-page PDF → one part, no crash.
- [ ] 800+ page PDF → progress bar moves, page stays responsive, only the first
      250 cards render with a note that all are exported.
- [ ] Plain `.txt` → pseudo-pages of ~3,000 characters, PDF export greyed out.
- [ ] Password-protected PDF → readable error, not a blank page.

Test in Chrome and Firefox, and once on a phone. Clipboard copy is restricted on
some mobile browsers; a toast says so, which is intended.

---

## 4. Hosting

Live on **Cloudflare Pages**, connected to this GitHub repository. Every commit
to `main` redeploys automatically within seconds — there is no manual publish
step.

To reproduce the setup: Cloudflare dashboard → **Workers & Pages** → **Create
application** → the *"Looking to deploy Pages?"* link → **Connect to Git** →
select the repository → **Begin setup**, then:

- Framework preset: **None**
- Build command: **empty**
- Build output directory: **empty**
- Production branch: `main`

**Commit the `lib/` folder.** It is not fetched at deploy time; a `.gitignore`
rule that excludes it will break the live site silently. This is the only common
failure.

HTTPS is automatic and required — clipboard access is blocked on plain HTTP.

A custom domain attaches under **Custom domains** in the Pages project. If the
domain is registered with Cloudflare the setup is instant; from another
registrar, add a CNAME pointing at the `pages.dev` address.

---

## 5. Problem reports

The **Something wrong?** section at the bottom of the app builds a report from
what the tool was actually doing — page count, outline source and depth, detected
offset, how many parts were cut at a heading versus cut for length, current
settings, browser. No page content, no file name, nothing personal. The user can
read and edit all of it before sending.

Reports go to GitHub Issues. The address is set at the top of the script block in
`app.html`:

```js
const FEEDBACK = {
  email:  "",
  issues: "https://github.com/soroushnajar-arch/signature/issues/new"
};

const VERSION = "1.1";
```

Add an `email` to show a **Send by email** button alongside. Bump `VERSION`
whenever you change anything, so reports say which build they came from.

---

## Known limits

- **Scanned pages can't be read.** No text layer, no text. Chunkbook does not do
  OCR and there is no plan to add it. When it meets a scanned PDF it hands over a
  ready-made `ocrmypdf` command, with the right language pack for the book, that
  adds an invisible text layer to the same file — appearance unchanged, words
  selectable. Bring the result back and everything here works on it. It can still
  cut such a PDF into smaller page-range PDFs in the meantime.
- **Token counts are estimates**, derived from character mix rather than a real
  tokenizer. Expect ±15% and leave headroom.
- **Heading detection is heuristic** when a book has no built-in contents list.
  It says so plainly when guessing and recommends cutting by hand.
- **Nothing is saved.** Close the tab and the ranges you typed are gone.
- **No EPUB yet.** Only PDF, plain text and Markdown.

---

## Licence

MIT — see [LICENSE](LICENSE). Copyright (c) 2026 Soroush Najjar.

Built on [pdf.js](https://mozilla.github.io/pdf.js/), [pdf-lib](https://pdf-lib.js.org/) and
[JSZip](https://stuk.github.io/jszip/), each under its own licence.
