# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Public, mixed audience with no single priority reader:

- **Recruiters and companies** evaluating the team (or individual members) for roles and projects; they need to grasp technical and product competence in a few minutes.
- **Command and institution** (ESA officers, other military organizations) who need to understand the value of the system.
- **Technical community** (developers and peers) interested in architecture decisions and demonstration code.

All of them arrive cold, usually from a link (GitHub, LinkedIn, a résumé), and read on desktop or phone. The page must serve a quick skim and a deeper read without favoring one audience over the others.

## Product Purpose

A public technical portfolio for **Atalaia** and **Gavião**, the academic management systems of the Escola de Sargentos das Armas (ESA), maintained by COP Educação and in production since 2020. Atalaia covers the 1st year of the CFGS (Período Básico, at the UETEs); Gavião covers the 2nd year (Período de Qualificação, at the ESA).

The portfolio shows what the system does and how it was built, without exposing the private institutional code or data.

**Success:** the reader gets in touch with the team. Understanding the system and exploring the examples are the paths that lead there.

## Positioning

A real system with six years in production, built and kept running by a small team inside a military intranet that blocks CDNs. It covers the whole two-year sergeant training cycle, from importing the exam results to choosing the specialty (QMS), plus a command dashboard and an offline Android app for disciplinary records in the field. Its proof comes from real operation, not from a demo project.

## Operating Context

- Published as a static site on GitHub Pages (`docs/`), with a separate examples page (`docs/examples/`) and the GitHub repository as the deeper layer.
- Readers come from external links and need no login.
- The underlying system runs on an intranet without CDN access. This shapes the engineering story the portfolio tells.

## Capabilities and Constraints

- **Stack (existing):** plain static HTML, CSS, and JavaScript, with no build step. Assets live in `docs/assets/`. Validation runs with `pwsh -NoProfile -File tests/validate-portfolio.ps1`.
- **Privacy is a hard constraint.** Never publish the full source or institutional Git history, credentials, tokens, internal addresses, production database names, personal data of students, restricted documents, or captures that identify internal people or environments. Screenshots come from the staging environment with a test user, with names and headcounts blurred (see `docs/screenshots/README.md`).
- **Demonstration code is authored for the portfolio.** Everything in `examples/` has fictitious names, tables, and data, and it is not a copy of the private repository.
- **The six product-front names** (Ciclo de Formação, Avaliação & Desempenho, Inteligência Educacional, Jornada Disciplinar, Escolha de QMS, Operação Móvel Offline) were created for the portfolio and do not replace institutional terminology.
- **Domain terminology to keep as-is:** CFGS, UETEs, ESA, SSAA, GBO, TFM, FO, FATD, FRAD, ROD, QMS, Painel Oficial do Diretor.
- **Open decision:** there is no contact channel on the page yet, even though contact is the success action. Which channels to publish (e-mail, LinkedIn, GitHub profiles), and for whom (the team or individuals), is undecided. Do not invent contact details.

## Brand Commitments

- **The names Atalaia and Gavião are fixed.** Gavião's existing identity (the colors, the ESA opening vignette, the radar that locks onto each module) must be preserved.
- **The ESA logo is authorized** to appear on the portfolio (`docs/assets/logo-esa.svg`).
- **Team names and photos are authorized and stay:** João Victor Gomes da Silva (Gestão; criou o sistema em 2020, avaliações, demonstrativo e classificação, escolha de QMS, painel público do COP Educação), Alexandre José Ferreira (Desenvolvimento e Dados; app Android Gavião FO e API móvel, lançamento de FO e FATD, Saúde Operacional, nota atitudinal N1 e N4 SIESP, Perfil de Comando), Natanael Cirino Guilherme Gomes (Desenvolvimento; Painel Oficial do Diretor, Conselho de Ensino, relatórios e estatística de FO, modo de navegação com o radar, mapa do concurso). Contributions come from the private repository commit history. Photos are in `docs/assets/team/`.
- All copy is in Brazilian Portuguese. No binding tone was set beyond being factual about real capabilities.

## Evidence on Hand

- **Presentation video:** a 43-second walkthrough of Gavião (`docs/assets/gaviao/apresentacao.mp4`, poster `apresentacao-poster.jpg`).
- **Real staging screenshots and animations** (`docs/assets/gaviao/`): login screens for Atalaia and Gavião, the navigation-mode hero, and the overview GIF.
- **Android app screenshots** (`docs/assets/mobile/`): the login screen and the FO lookup by student.
- **Documentation:** the architecture docs (`docs/arquitetura/`), the component diagrams (`docs/diagramas/`), and the mobile technical overview (`docs/mobile/README.md`).
- **Demonstration code** (`examples/`):
  - the dashboard bands;
  - dropout counting that handles reinstated students;
  - merit-based QMS choice;
  - Jenks natural breaks;
  - the offline FO queue.
- **Timeline from 2020 to 2026**, derived from the private commit history.
- **Absent, and not to be fabricated:** testimonials, usage metrics or user counts, real dashboard data, press coverage, awards, and contact details.

## Product Principles

1. **Proof over claims.** Show the real system working (video, screens, decisions with reasons) rather than adjectives.
2. **Privacy by design is part of the story.** What is hidden is hidden on purpose, and the page says so plainly.
3. **Serve the skim and the deep read.** A recruiter should get the essentials in seconds, and an engineer should be able to keep going into the architecture and the code.
4. **Every path ends near contact.** Understanding the system should lead naturally to reaching the team.
5. **Accuracy to the domain.** Use the institution's terms correctly and do not inflate capabilities.
