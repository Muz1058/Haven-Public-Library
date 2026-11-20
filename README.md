# Readers' Haven Public Library

A university DevOps assignment using plain HTML and CSS. Parcel builds the five
pages; nginx serves the generated files. There is no application JavaScript or backend.

## Team ownership

| Role | Page(s) | Branch | Image tag | Host port |
| --- | --- | --- | --- | --- |
| Team Lead: `muz1058` | `src/index.html` | `feature/index-page` | `v1-index` | 8081 |
| Member 1 / CSS lead: `aleena-coded` | `src/collections.html`, shared CSS | `feature/collections-page` | `v1-collections` | 8082 |
| Member 2: `Code-fever1` | `src/membership.html`, `src/contact.html` | `feature/membership-contact-pages` | `v1-membership-contact` | 8083 |
| Member 3 / evidence and QA: `Talha331-web` | `src/services.html` | `feature/services-page` | `v1-services` | 8084 |

Team Lead Docker Hub: `silentaxiom`. Collaborators and reviewers: `Talha331-web`,
`aleena-coded`, and `Code-fever1`. Member assignments are confirmed above; their
individual Docker Hub usernames still need confirmation.
The work plan proposes four people for a five-person assignment: confirm this with
the instructor and mark row 5 N/A in Tables 1 and 2 only after agreement.

Each member replaces their own placeholder. Member 1 owns the shared CSS base;
append page-specific rules in named sections with page-prefixed classes.
All HTML belongs in `src/` and links `../styles/style.css`.

```text
src/
  index.html
  collections.html
  membership.html
  services.html
  contact.html
styles/style.css
package.json
package-lock.json
.gitignore
.dockerignore
Dockerfile          # available on feature/dockerfile until its PR is merged
dist/               # generated, ignored
```

## Local development (Task 9)

Use Node.js 24.x and npm. On Windows PowerShell, use `npm.cmd` if script execution
policy blocks `npm.ps1`; no policy change is needed. Elsewhere, use `npm`.

```powershell
node --version
npm.cmd --version
npm.cmd ci
npm.cmd run build
Get-ChildItem -Force dist
Select-String -Path dist/*.html -Pattern '\.css'
git ls-files dist
git status --short
```

`dist/` must contain all five HTML pages and generated CSS. `git ls-files dist`
must print nothing. `npm.cmd start` provides the Parcel development preview at
`http://localhost:1234/`. `dist/`, `node_modules/`, `.parcel-cache/`, credentials,
and `.env` files must never be committed.

## Baseline and collaboration (Tasks 1–3)

This checkout started with only `main`; local `develop` was created from it with
the repository owner's approval. The baseline is committed on local `develop`.
No remote changes are implied by these instructions.

The first baseline commit is `18c3b1a`. The Dockerfile commit is `1764666` on
`feature/dockerfile`. The home page has five separate implementation commits on
`feature/index-page` (`73e9594`, `1258ac9`, `59265dc`, `3ef82ae`, `43eb401`).
Use `git log --oneline develop..feature/index-page` and
`git log --oneline develop..feature/dockerfile` to inspect the current lists.

When ready to publish the reviewed baseline:

```powershell
git switch develop
git push -u origin develop
```

In GitHub Settings, invite `Talha331-web`, `aleena-coded`, and `Code-fever1`. Protect `develop` with required
pull requests and **2 approving reviews**, and `main` with **3 approving reviews**.
Require conversation resolution and disallow force pushes/deletions on those
protected branches. Check that protection is actually enforced for this repository.
Set `develop` as the normal base for feature PRs.

Create exactly these five issues with the confirmed assignees below:

| Issue title | Owner | Acceptance criteria |
| --- | --- | --- |
| `[Feature] Index Implementation` | Team Lead `muz1058` | Home page, shared navigation, responsive layout, successful build |
| `[Feature] Collections Implementation` | Member 1 `aleena-coded` | Four categories, three featured books each, shared CSS base |
| `[Feature] Membership Implementation` | Member 2 `Code-fever1` | Three plans, annual fees in PKR, borrowing/loan/late-return rules |
| `[Feature] Contact Implementation` | Member 2 `Code-fever1` | Address, phone, email, static name/email/message form |
| `[Feature] Services Implementation` | Member 3 `Talha331-web` | Services page, responsive layout and shared navigation |

Link each page PR to its issue. The home page and Dockerfile use separate branches.
The earlier Member 1 CSS commits remain on local `feature/collections-page`; its
uncommitted draft pages were saved in a named Git stash before the role correction.
Do not push that old branch or apply that stash onto Team Lead work without review.

## Dockerfile first (Task 7)

`feature/dockerfile` contains the one multi-stage Dockerfile. It installs the locked
Parcel development dependency in a Node.js build stage, then copies only `dist/`
into an nginx runtime. Dependency inputs are copied before page content so edits
to HTML/CSS can reuse the install layer. nginx stays in the foreground on port 80.

After publishing the baseline, publish this branch for review:

```powershell
git switch feature/dockerfile
git fetch origin
git rebase origin/develop
git push -u origin feature/dockerfile
```

Open a PR into `develop`, assign `muz1058`, and request reviews from the other
three people. Merge only after two approvals. Do not bypass this PR with a local
merge. Then update the Team Lead home branch:

```powershell
git switch feature/index-page
git fetch origin
git rebase origin/develop
git push -u origin feature/index-page
```

Open the home PR into `develop`, with the same assignee and reviewers and two
approvals. If a published feature branch needs another rebase, coordinate with
reviewers and update that feature branch using `git push --force-with-lease`.
Never force-push `develop` or `main`.

For a local check before the Dockerfile PR is merged, the following reads the
committed Dockerfile directly from its branch while building your current home-page
files. It does not merge the branches or create a second Dockerfile:

```powershell
git switch feature/index-page
git show feature/dockerfile:Dockerfile | docker image build --progress=plain -f - -t silentaxiom/readers-haven:v1-index .
```

Run it twice unchanged to inspect caching. Once the Dockerfile is merged and your
branch is rebased, use the ordinary build commands in the next section.

## Individual Docker evidence (Tasks 4–6, 10–12)

Start Docker Desktop with Linux containers. Use only Docker management commands;
do not use volumes, custom networks or Compose. Take screenshots of your own output.
If a named container already exists, inspect it before deciding whether to reuse or
remove it. Stop and remove only containers created for this assignment.

Tasks 4–6, using the assignment's nginx image and a temporary container:

```powershell
docker version
docker info
docker image pull nginx:1.27-alpine
docker image ls
docker container run -d --name haven-muz1058-nginx -p 8081:80 nginx:1.27-alpine
docker container ls
curl.exe -I http://localhost:8081/
docker container logs haven-muz1058-nginx
docker container stop haven-muz1058-nginx
docker container ls -a
docker container start haven-muz1058-nginx
docker container inspect haven-muz1058-nginx
docker image history nginx:1.27-alpine
docker image inspect nginx:1.27-alpine
docker container stop haven-muz1058-nginx
docker container rm haven-muz1058-nginx
```

Tasks 10–12, **after the Dockerfile PR is merged and your branch is rebased**:
The Team Lead image is `silentaxiom/readers-haven:v1-index`.
Create a Public Docker Hub repository named `readers-haven` under `silentaxiom`.

```powershell
$dockerHubUser = 'silentaxiom'
$imageTag = "${dockerHubUser}/readers-haven:v1-index"
docker image build --progress=plain -t $imageTag .
docker image build --progress=plain -t $imageTag .
docker image ls
docker image history $imageTag
docker container run -d --name haven-muz1058-nginx -p 8081:80 $imageTag
docker container ls
docker container logs haven-muz1058-nginx
curl.exe -I http://localhost:8081/index.html
curl.exe -I http://localhost:8081/collections.html
curl.exe -I http://localhost:8081/membership.html
curl.exe -I http://localhost:8081/services.html
curl.exe -I http://localhost:8081/contact.html
docker container stop haven-muz1058-nginx
docker container rm haven-muz1058-nginx
docker login --username $dockerHubUser
docker image push $imageTag
docker image rm $imageTag
docker image pull $imageTag
docker image ls
```

At the login password prompt, paste a Docker Hub **access token**, not your account
password. Never place the token in a command, file, screenshot, or commit.
Record the actual steps marked `CACHED` by the second build; do not claim cache hits
without that output. Open `http://localhost:8081/` while the container is running
for the browser screenshot.

## Release and final image (Tasks 14–16)

These are later steps. Wait for all page PRs, the shared CSS, and the Dockerfile
to be merged into `develop`; placeholders are not a finished release. Member 3
checks all five pages, links and mobile layouts before release approval.

```powershell
git switch develop
git pull --ff-only origin develop
git switch -c release/v2.0
npm.cmd ci
npm.cmd run build
git push -u origin release/v2.0
```

Open `release/v2.0` into `main`, assign `muz1058`, and obtain approvals from all
three teammates before merging. Bring the release back into `develop` through a
reviewed PR from `main` to `develop`, following its two-approval rule.

Build the final image from the merged release on `main`:

```powershell
git switch main
git pull --ff-only origin main
$dockerHubUser = 'silentaxiom'
$finalImage = "${dockerHubUser}/readers-haven-final:v2.0"
docker image build -t $finalImage .
docker login --username $dockerHubUser
docker image push $finalImage
docker image pull $finalImage
docker container run -d --name haven-muz1058-final -p 8081:80 $finalImage
curl.exe -I http://localhost:8081/index.html
docker container ls
docker container logs haven-muz1058-final
docker container stop haven-muz1058-final
docker container rm haven-muz1058-final
```

Create `readers-haven-final` as Public before pushing. Each teammate pulls the
Team Lead's final image and uses their assigned port and a distinct container name.

## Screenshot checklist

This mapping follows the supplied four-person work plan; check the original marking
sheet for exact substeps. Capture genuine results, not prepared commands alone.

| Task | Evidence to capture |
| --- | --- |
| 1 | Repository files, `git log --oneline develop`, Parcel scripts and committed lockfile |
| 2 | Collaborators; enforced protection showing 2 approvals on develop and 3 on main |
| 3 | Five assigned GitHub issues; `git remote -v`; `git branch -a` |
| 4 | `docker version`; `docker info`; successful nginx image pull |
| 5 | nginx `docker container run`, `ls`, `logs`, `stop`, `ls -a`, `start`, `inspect`, `rm`; browser welcome page |
| 6 | `docker image ls`; `docker image history nginx:1.27-alpine`; `docker image inspect nginx:1.27-alpine` |
| 7 | Dockerfile's two stages and reviewed Dockerfile PR into develop |
| 8 | Home page at desktop and phone widths; its CSS media queries; `git log --oneline` |
| 9 | `npm.cmd ci`; `npm.cmd run build`; `Get-ChildItem -Force dist`; CSS references; empty `git ls-files dist` |
| 10 | Both custom builds, actual `CACHED` lines on the second, `docker image ls`, `docker image history $imageTag` |
| 11 | Custom container run/list/logs; HTTP 200 responses and browser page on port 8081 |
| 12 | Successful token login (no token visible), image push, Public Hub tag, image removal and pull |
| 13 | Fetch/rebase output, home PR into develop, assignee/reviewers, two approvals and merge |
| 14 | release/v2.0 PR into main, three approvals and merge; merge back into develop |
| 15 | Final image build/push and Public `readers-haven-final:v2.0` tag |
| 16 | Final image pull/run/list/logs and browser screenshot on each member's port |

In Git Bash, `ls -la dist` gives the assignment's literal directory-list command;
PowerShell's equivalent is `Get-ChildItem -Force dist`.

The Team Lead compiles Tables 1 and 2 using verified names, IDs, emails, GitHub and
Docker Hub identities, repository/PR/image links, and actual evidence. The original
table templates and teammates' details are still needed; do not invent them.
Member 3 supplies the 3–4 line teamwork/challenges note after the work is complete.

## Local verification completed on 21 November 2026

- Node.js `24.21.0` and npm `11.19.0`; used `npm.cmd` because PowerShell blocks
  `npm.ps1`. No global execution-policy change was made.
- `npm.cmd ci` and `npm.cmd run build` passed. The agent's sandbox initially blocked
  SWC's user-cache access; the same build passed with access to the normal user cache.
- All five generated HTML pages refer to the generated CSS. Source and built
  navigation links, metadata, heading order and active-page markers were checked.
- `dist/`, dependencies and caches are ignored and untracked; `ls -la dist` was run.
- Browser device-emulation checks at 320, 390, 768 and 1440 pixels passed without
  horizontal overflow. Navigation and cards stack at the required mobile widths.
  Local preview captures are in ignored `.parcel-cache/verification/`; they do not
  replace your own assignment screenshots.
- nginx pull, HTTP 200, start/stop/restart, logs, inspect and removal checks passed.
- `silentaxiom/readers-haven:v1-index` built twice using the Dockerfile branch as
  stdin. The second build reported `CACHED` for `WORKDIR`, package-file copy,
  `npm ci --include=dev`, source copy, styles copy, `npm run build`, and the final
  `COPY --from=build` into nginx.
- All five pages and their stylesheet returned HTTP 200 from the custom container
  on port 8081. Node and build dependencies were absent from its runtime filesystem.
  Assignment test containers were stopped and removed; the local image remains.
- No Git pushes, Docker login/push, collaborator invitations, protection changes,
  issue creation, PR creation or release operations were performed. Those steps
  require the handoff workflow above. The four other pages remain placeholders.

## Technical references

- [Parcel HTML entry points and build options](https://parceljs.org/features/cli/)
- [Docker multi-stage builds](https://docs.docker.com/build/building/multi-stage/)
- [Node.js release lines](https://nodejs.org/en/about/previous-releases)

