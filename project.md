
# Agentic Coworkers Round 2 — Canonical Plan (Agentic Coworker)

## Summary
An **Agentic Coworker** is a standalone, autonomous agent that operates as a distinct individual — equivalent to a single human employee.
It runs in its own private runtime and collaborates with humans and other coworkers via shared workspaces.

**Mental model: think human team, not AI swarm.**
Each coworker has its own brain (private memory), its own job, its own responsibilities, and possibly its own tools.
They share an office (Slack) and a shared drive (Obsidian GitHub repo) — not a shared brain.
When someone looks at the Slack channel, they see a team doing work.

Collaboration surfaces:

- Slack channels — the office where coworkers and humans interact
- Shared Obsidian GitHub repository — the team's shared drive for work product, notes, and project files

**This repository is the template deployment.**
It defines the base "employee onboarding kit" that gets customized when spinning up a specific coworker.
Core files are split into two concerns:

- **Universal (template):** how any coworker operates — office culture, collaboration etiquette, shared workspace usage
- **Role-specific (per deploy):** who this coworker is — persona, job title, responsibilities, specific tools

---

## Framework & Infrastructure

Primary framework: `HKUDS/nanobot`
- Native tools: filesystem, shell/CLI (`exec`), web search, cron, spawn/subagents, MCP
- Extension mechanism: MCP servers (nanobot auto-registers MCP tools at startup)

Why nanobot:
- Lightweight harness; most compute happens at model providers (API-based)
- Built-in tool system + safety guardrails
- MCP support avoids custom fork/tooling where possible

Hosting / deployment target (for persistence + individuality): DigitalOcean
- Host type: DigitalOcean Droplet (Basic)
- Runtime: Docker
- Isolation model: **each coworker runs as a singular container** on the droplet to maintain strict isolation of filesystem + processes

---

## Persistence model

Individual brain (local, unique per coworker)

- Identity, core files, and memory are local to the coworker container and unique per coworker.
- This is the coworker's private brain — not shared with anyone.
- May be reconfigured by the coworker (within guardrails) or by explicit user command.

Shared workspace (cross-coworker)

- Coworkers share an Obsidian GitHub repository as the team's shared drive.
- This is for work product, project files, and shared notes — not personal memory.
- Analogous to a team's shared Google Drive or GitHub org.

---

## Requirements list

To deploy a singular Agentic Coworker, the following stack is required.
Requirements 1–3 are the minimum.

### Core requirements (minimum)
1) Nanobot system environment via Docker
- Core files (prompts/configs) edited specifically for this coworker persona/deployment.

2) LLM API key
- Access to the reasoning engine (e.g., Anthropic, OpenAI, etc.).

3) Individual Slack App
- Dedicated Slack bot user
- Socket Mode enabled
- Installed to workspace and added to required channels

### Extended requirements (recommended / role-dependent)
- Shared GitHub repository access
  - Fine-grained PAT (or deploy key / GitHub App) with least-privilege access to the shared brain repo

- Brave Search API key
  - For real-time web intelligence via nanobot web search tooling

- Browser automation runtime
  - Playwright + browser-use capability via MCP servers
  - Optional: site credentials for authenticated browsing flows (only where needed)

---

## Modifications list (what we must build/change)

### 1) Browser use — tool implementation
- Nanobot does not ship Playwright/browser-use natively.
- Solution: add **Playwright MCP** (and browser-use MCP or equivalent) since nanobot supports MCP integrations.

### 2) Identity and soul — core logic/content change
- Baseline: rewrite existing core files for desired behavior + expected collaboration capability.
- Deployment-specific: append persona + identity to core files (including `SOUL.md`) so the coworker is consistent and role-aligned.

### 3) Collaboration logic — core logic/content change
- Add a new core file focused on:
  - collaboration boundaries
  - awareness of other coworkers and their responsibilities
  - preventing “task stealing” when another coworker is already responsible
- This file is editable by the coworker as it learns the coworking environment.

---

## Deployment workflow

1) Provision DigitalOcean droplet; clone base repository
2) Create Slack App/Bot user; install to Slack; configure channels; enable Socket Mode
3) Create / configure shared Obsidian GitHub repository; provision access token/keys (least privilege)
4) Ensure access to LLM API key, Brave Search key (if used), and browser automation MCP (Playwright/browser-use)
5) SSH into droplet; edit core files and set unique env keys for this coworker
6) Deploy container
7) Invite coworker into target Slack channels for testing + onboarding

---

## Notes / open questions (for follow-up)
- Decide if shared repo writes are direct-to-main vs PR-only (recommended PR-only or “librarian coworker”).
- Decide whether browser MCP servers run inside coworker containers vs sidecar services.
- Decide credential strategy (PAT vs deploy key vs GitHub App).