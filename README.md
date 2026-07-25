# Signature

Cuts a long document into labelled parts that fit in a chat window — along its own
chapter boundaries, or along page ranges you set by hand.

Everything runs in the browser. No server, no build step, no upload.

```
signature/
├── index.html      landing page
├── app.html        the splitter
├── setup.sh        downloads the libraries (macOS / Linux)
├── setup.ps1       downloads the libraries (Windows)
├── README.md       this file
└── lib/            created by setup — four .js files, about 2 MB
```

---

## 1. Setup

The libraries are not included, because they are somebody else's code and they
change. Fetch them once:

**macOS / Linux**

```bash
bash setup.sh
```

**Windows**

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

The script downloads four files into `lib/`, then checks each one is a real
library rather than an error page saved under the right name.

If you'd rather do it by hand, download these into `lib/` keeping the filenames:

| File | Source |
|---|---|
| `pdf.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js` |
| `pdf.worker.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js` |
| `jszip.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js` |
| `pdf-lib.min.js` | `https://cdnjs.cloudflare.com/ajax/libs/pdf-lib/1.17.1/pdf-lib.min.js` |

Keep these versions. pdf.js 4 and later changed to ES modules and will not work
with this code.

---

## 2. Run it locally

**Do not open `app.html` by double-clicking it.** Browsers block web workers on
`file://` URLs, so PDF reading will fail. Serve the folder over HTTP instead:

```bash
cd signature
python3 -m http.server 8000
```

Then open <http://localhost:8000>.

Any static server works — `npx serve`, `php -S localhost:8000`, whatever you have.
If setup is incomplete or you opened the file the wrong way, the page says so and
tells you which command to run.

---

## 3. Check it works

Fifteen minutes with a real book beats any amount of reading the code. Use a PDF
you know well — ideally one with proper bookmarks, and a second one without.

**Reading the file**

- [ ] Page count in the top bar matches the real page count.
- [ ] Word and token counts are non-zero and roughly plausible.
- [ ] "Outline entries" says `bookmarks` for a PDF that has them, `detected` for
      one that doesn't.
- [ ] The detected structure list shows chapter titles you recognise, with page
      numbers that are actually right. Spot-check three.

**Cutting from the outline**

- [ ] Press *Build parts*. The parts list appears and the bar underneath goes blue
      end to end, with no grey gaps.
- [ ] Preview a part. The text starts at that chapter, not halfway through the
      previous one.
- [ ] No part is flagged red for exceeding the maximum.
- [ ] Change *Split at level* from 2 to 1 and rebuild — you should get noticeably
      fewer, bigger parts.
- [ ] Set the maximum to something small, like 2000, and rebuild. Oversized
      chapters should split into `(1/3)`, `(2/3)`, `(3/3)` and the split should
      land between paragraphs, never mid-sentence.
- [ ] With overlap set above zero, the start of part 2 repeats the tail of part 1
      after a leading `…`.

**Manual ranges**

- [ ] *Add a range*, type a name and a page span. It appears in the parts list
      immediately with the right token estimate.
- [ ] Type a last page past the end of the book. The row turns red and a warning
      names the valid range.
- [ ] *Split evenly into 10* covers the whole bar with ten equal segments.
- [ ] Delete a range from the middle. A grey gap appears in the bar.
- [ ] *Add uncovered pages as parts* fills that gap.
- [ ] Two overlapping ranges show gold in the bar where they cross.
- [ ] *Copy outline parts here* fills the table with the chapters, editable.

**Export**

- [ ] *Copy* on a part puts the label block plus the text on the clipboard.
- [ ] *Download all as ZIP* produces numbered `.md` files, `_index.md` and
      `manifest.json`.
- [ ] Open a chunk file. The header lists the right part number, page range and
      neighbours.
- [ ] Switch the format to *PDF page slices* and export. Each PDF opens and
      contains exactly the pages its name claims.
- [ ] `manifest.json` parses as valid JSON.

**Edge cases worth trying once**

- [ ] A scanned PDF with no text layer. Expected: a red notice explaining there is
      nothing to read, the tool switching itself to manual mode and to PDF export.
      It should not silently produce empty parts.
- [ ] A one-page PDF. Expected: one part, no crash.
- [ ] A very large PDF, 800 pages or more. Expected: the progress bar moves and
      the page stays responsive. This is the slow path — a minute or two is normal.
- [ ] A plain `.txt` file. Expected: it is treated as pseudo-pages of about 3,000
      characters each, and the PDF export option is greyed out.
- [ ] A password-protected PDF. Expected: a readable error, not a blank page.

**Browsers**

Test in Chrome and Firefox at least, and once on a phone. Clipboard copy is
restricted on some mobile browsers — if it fails you get a toast saying so, which
is the intended behaviour.

If something breaks, open the browser console first. Errors are logged there with
enough context to say which stage failed.

---

## 4. Put it on the internet

There is no backend, so hosting is free and stays free. Pick one.

### Netlify Drop — fastest

1. Go to <https://app.netlify.com/drop>.
2. Drag the whole `signature` folder onto the page.
3. You get an HTTPS address in under a minute.

No account needed to start, though you'll want one to keep the site and rename it.

### Cloudflare Pages — best reach

1. Sign in at <https://dash.cloudflare.com> → **Workers & Pages** → **Create** →
   **Pages** → **Upload assets**.
2. Upload the folder. Leave the build command empty; this is not a build.
3. Deploys to `yourproject.pages.dev`.

Cloudflare's network is the fastest of the three in most of Asia and the Middle
East, which matters if that's where your users are.

### GitHub Pages — most permanent

1. Create a repository and push the folder contents to the root of `main`.
2. **Settings → Pages → Source: Deploy from a branch**, pick `main` and `/ (root)`.
3. Live at `https://yourname.github.io/reponame/` in a couple of minutes.

The source stays public, which fits a tool whose main claim is that nothing leaves
your machine — anyone can check.

### Notes for all three

- `index.html` is served automatically at the root. The links to `app.html` are
  relative, so nothing needs changing.
- **Commit the `lib/` folder.** It is not downloaded at deploy time. If you use
  `.gitignore`, make sure it doesn't exclude `lib/`.
- A custom domain is free on all three; you only pay for the domain itself.
- HTTPS is automatic everywhere, which the tool needs — clipboard access is
  blocked on plain HTTP.
- No cookies, no analytics, no accounts, and no file ever leaves the browser, so
  there is nothing to write a privacy policy about. Saying that plainly on the
  page is worth more than a policy nobody reads.

---

## 5. Collecting problem reports

The app has a **Something wrong?** section at the bottom. It builds a report from
what the tool was actually doing — page count, outline source and depth, detected
page offset, how many parts were cut at a heading versus cut for size, the current
settings, and the browser. No page content, no file name, nothing personal. The
user can read and edit all of it before sending.

Out of the box only **Copy the report** appears. To add the other two buttons, edit
the top of the script block in `app.html`:

```js
const FEEDBACK = {
  email:  "you@example.com",
  issues: "https://github.com/you/signature/issues/new"
};
```

Fill in either, both, or neither:

- `email` adds **Send by email** — opens the user's mail client with everything
  prefilled. No service to sign up for, but you get reports into a personal inbox
  and nobody else can see that a bug was already filed.
- `issues` adds **Open an issue** — opens a prefilled GitHub issue form. Best if the
  repository is public: reports are visible, searchable, and duplicates stop
  arriving. Point it at any issue tracker that accepts `?title=` and `?body=`.

Leave both empty and the report is still useful — the user copies it and sends it
however they like.

Bump `VERSION` in the same block when you change anything, so reports say which
build they came from.

---

## Known limits

- **Scanned pages can't be read.** No text layer, no text. Signature does not do OCR and there is no plan to add
  it — run the file through an OCR tool first. The splitter can still cut such a PDF into smaller page-range PDFs
  in the meantime.
- **Token counts are estimates**, derived from character mix rather than a real tokenizer. Expect ±15% and leave
  headroom.
- **Heading detection is heuristic** when a book has no built-in contents list. It says so plainly when it is
  guessing, and recommends cutting by hand instead. Every cut can be corrected either way.
- **Nothing is saved.** Close the tab and your ranges are gone.
- Outline mode is tuned for English. Manual ranges work with any language, since
  they never read the text.
