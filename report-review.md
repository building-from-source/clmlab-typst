# Report review

Reviewed on 2026-09-26. Source locations refer to the version reviewed.

Follow-up on 2026-09-26: the author confirmed the simple-scenario wording and
noted that it may have been adapted for the study. The report now attributes
these definitions to the instructions given to participants. The Introduction,
product/condition labels, bootstrap terminology, and outcome descriptions have
been revised. The findings below document the review before those revisions;
their line references may have shifted.

A subsequent revision expanded the pilot description using the author's recollection, added an explicit contribution statement and a conclusion, and added existing citations to the Introduction.
The Christensen reference now identifies an online manuscript with its CRAN URL and access date; no unverified publication year is supplied.
Implementation details were initially deferred, and the author requested that A/B record handling and the omission of free-form response analysis remain outside the report.
The implementation section now describes the architecture, bootstrap procedure, and separate LLM features using details supplied by the author.
The architecture account was condensed to the main components and modeling workflow, with storage details omitted at the author's request.
The report also explains the chatbot's prompt context and describes the study interface as a hard-coded prototype in place of the earlier "Wizard of Oz" terminology.
The application source has not been independently checked as part of these revisions.

## Overall assessment

The report has a sensible overall structure, and the reported study averages are consistent with the saved analysis. It distinguishes the implemented tool from the prepared study interface and acknowledges several important limitations.

The main issues are inconsistencies in the study materials, insufficient documentation of what was evaluated, and gaps in the statistical implementation description. Resolve these before polishing the prose. Several findings below concern screenshots that the appendix presents as the study condition. Their status as original study materials or later reconstructions needs to be explicit.

I reviewed the report source, appendix, figures, bibliography, questionnaire, analysis notebook, task instructions, datasets, and saved model output. I compiled the report with its bundled fonts, inspected the rendered layout, recalculated the aggregate results from the prepared participant data, and re-fitted both scenario models. I checked relevant passages in the supplied papers and external primary documentation. The report and study source files were left unchanged.

The model checks used locally installed `ordinal` 2025.12.29, rather than the 2026.7-26 version cited in the bibliography. They corroborate the substantive numerical findings below but do not establish the original study's software environment. I did not verify the application implementation because its source is not part of this report repository, or rerun the subsampling script because `lme4` is not installed.

## Findings to resolve first

### 1. The prepared interaction interpretation conflicts with the scoring criterion

**Priority: high.** Locations: [study design](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:395), [Figures A.3 and A.4](/Users/julian/repos/github.com/building-from-source/clmlab-typst/appendix.typ:65), [saved interaction estimate](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Studie/complex_fit_model_output.txt:20), and the `INTERACTION_ANSWER` definition in [the analysis notebook](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Auswertung/prepare_data.ipynb).

The complex-scenario summary says the course-type effect “depends heavily” on study stage and calls the interaction “marginally significant.” The predicted-probability interpretation says a study-stage effect “disappears” and is “absent” in service courses. The saved interaction p-value is 0.05103, while the correct questionnaire answer says the interaction is not significant at alpha = .05.

This goes beyond a stylistic discrepancy: participants could follow the supplied interpretation and still answer against the intended scoring criterion. A non-significant simple effect does not establish absence of an effect, and differing significance decisions for two simple effects do not establish their difference. See [Gelman and Stern's paper](https://stat.columbia.edu/~gelman/research/published/signif4.pdf).

**Suggested action:** establish whether these exact interpretations were shown during the study. If so, preserve them as historical materials and discuss the mismatch as a limitation. If the screenshots were reconstructed later, identify them as reconstructions and restore the actual study wording if available. For future materials, distinguish the observed pattern from uncertainty about the interaction. Also prefer “not statistically significant at alpha = .05” to the answer key's stronger “no statistical evidence.”

### 2. Model output and diagnostic messages disagree across figures and listings

**Priority: high.** Locations: [Figure 5.6](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:343), [Figures A.1 to A.4](/Users/julian/repos/github.com/building-from-source/clmlab-typst/appendix.typ:55), and [Listing A.4's source](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Studie/complex_fit_model_output.txt:24).

Concrete examples:

| Item | Study screenshot | Other evidence |
| --- | --- | --- |
| Complex model, threshold 1\|2 | Estimate -2.75, SE 0.22 | Saved R output: -2.8345, SE 0.3835 |
| Complex model, threshold 4\|5 | Estimate 0.45, SE 0.19 | Saved R output: 0.4606, SE 0.3306 |
| Simple model, proportional-odds diagnostic | Figure A.1 says no differences were detected across thresholds | Figure 5.6 flags `public` at p = .049; refitting and `nominal_test()` give p = .04877 |
| Complex model, predicted rating 5 for early-stage service courses | Figure A.4's text says 15% | Its plotted bar says 16% |
| Complex model, predicted rating 5 for late-stage non-service courses | Figure A.4's text says 21% | Its plotted bar says 22% |

The threshold differences are too large to be rounding alone. Different diagnostics or prediction conventions could explain some other discrepancies, but none are documented. The re-fitted complex model corroborates the saved thresholds at the displayed precision.

**Suggested action:** identify the model, diagnostic method, and prediction convention underlying each display. Explain whether screenshots are originals, later versions, or illustrations. If the displays were intended to represent the same fitted model, reconcile the values. Do not silently correct historical study materials. The present report does not establish numerical equivalence of the two study conditions.

### 3. Dataset provenance and variable meanings need correction or an explicit adaptation note

**Priority: high.** Locations: [simple scenario](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:444), [complex scenario](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:458), and [simple-scenario screenshots](/Users/julian/repos/github.com/building-from-source/clmlab-typst/appendix.typ:55).

The prose and archived instructions define `pared` as at least one parent holding a university degree; the interface calls it parental graduate education or a parent having attended graduate school. Holding any university degree, holding a graduate degree, and attending graduate school are different definitions.

The local simple dataset's variables, category counts, and fitted coefficients match UCLA's ordinal-regression example. This strongly suggests that source, but provenance should be confirmed. UCLA explicitly describes its data as simulated and defines `pared` as a parent having a graduate degree. The report currently describes responses from 400 students without distinguishing the scenario's fictional framing from the dataset's origin. [UCLA example](https://stats.oarc.ucla.edu/r/dae/ordinal-logistic-regression/)

For the complex scenario, the original `InstEval` definition of `service` concerns a lecture held for a department other than the lecturer's main department. It does not define mandatory attendance. The report and questionnaire recast this as a mandatory service course. [Official InstEval documentation](https://lme4.github.io/lme4/reference/InstEval.html)

**Suggested action:** cite both dataset sources, state which scenario descriptions were adapted, and distinguish the original variable definitions from what participants were told. Briefly explain that early/late study stage was derived from semesters 2/4 versus 6/8, as documented in [the preparation script](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Studie/derive_subsample.R:10).

## Methods and interpretation

### 4. Describe the evaluated displays before discussing why they may have helped

**Priority: medium.** Locations: [Study Design](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:390), [Discussion](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:517).

The Discussion introduces simple-effects plots and predicted-probability plots as explanations for the findings, but Study Design largely describes the treatment as a results page with prepared interpretations. Chapter 5 describes the implemented interface, which differs from the study interface. The appendix screenshots help, but the body does not direct readers to them when defining the conditions.

**Suggested action:** add a short “Study materials” subsection or comparison table covering the tables, plots, prepared text, diagnostics, interactions, and permitted aids in each condition. Link the appendix screenshots. State the LLM used to prepare the text, what context it received, and whether anyone checked or edited its output. Explain whether “Wizard of Oz” denotes simulated automated responses through fixed text or involved a human operator; add a methodological citation if retaining the term.

### 5. Complete the participant flow and pilot description

**Priority: medium.** Locations: [pilot](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:378), [participant counts](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:415), and [analysis notebook](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Auswertung/prepare_data.ipynb).

The final 95-person sample and the reported screening percentages check out. However, the notebook starts with 111 response records, retains 101 after initial filtering and deduplication, and resolves condition assignments for 96. Five retained records have A/B scenario labels and no method assignments. The report begins at 96 without explaining that preceding step.

The one resolved participant with an incorrect first screening answer has no scored task responses. The notebook does not explicitly filter on that answer; it omits unanswered task pages. Clarify whether screening ended that participant's survey or whether exclusion was an analysis decision.

The pilot has no participant count, duration, concrete task description, or explanation of how observations were recorded and summarized. These details matter because the pilot motivates changing the evaluation's focus.

**Suggested action:** briefly describe the sample flow, including the status of the five A/B records, and report the verified pilot count. Do not infer a count from the provisional source comment. Add a four-sequence allocation table and explain how allocation occurred. Among the 95 scored participants, the sequence counts are 26, 25, 22, and 22, consistent with approximate counterbalancing.

### 6. The aggregate result obscures the weakness on interaction interpretation

**Priority: medium.** Locations: [Results](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:474), [Discussion](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:524).

The overall complex-scenario difference is accurately reported. The item results make the conclusion more informative:

| Complex-scenario item | Tool | RStudio |
| --- | ---: | ---: |
| Service effects by study stage | 47.7% | 11.8% |
| Larger random-effect variance | 84.1% | 62.7% |
| Interaction | 34.1% | 35.3% |

These values were recalculated from [the item-level export](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Auswertung/prepared/performance_item_long.csv). They do not show an advantage on the interaction question. That matters because interactions motivate the tool and the Discussion emphasizes the simple-effects display.

**Suggested action:** add an item-level results table, at least in the appendix, and discuss the interaction result explicitly. Keep the distinction between interpreting simple effects and interpreting their interaction. State that the free-form responses were collected but were not analyzed in this report, if that is the case.

### 7. Add variability and explain the treatment of rating scales

**Priority: medium.** Locations: [Results and figures](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:472), [Limitations](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:528).

The figures contain means and mostly sample sizes, but no distributions, dispersion, or uncertainty. Figure 6.3 also omits its n = 95. The text appropriately calls the findings descriptive; there is no need to manufacture significance claims. Still, readers cannot judge how heterogeneous or uncertain the observed differences are.

The report motivates ordinal methods by questioning equal spacing of ratings, then summarizes its own 0-10 ratings only by means. This is not automatically invalid, but the scale's interpretation and the choice of summary need explanation. Give the response anchors and, preferably, show distributions or medians alongside means. Explain that the comparative sliders were reversed when necessary so higher values consistently favor the tool.

**Suggested action:** show participant-score distributions or appropriate intervals and report sample sizes for all outcomes. If inferential analyses are added, account for the repeated observations across scenarios and order. Within an individual scenario, the tool and RStudio scores come from different participants; they are not paired observations of the same scenario.

Also retain optional LLM use in the limitations: permission was established, but actual usage and its extent were not. The condition instructions emphasized LLM use differently, as documented in [the task-instruction record](/Users/julian/repos/github.com/building-from-source/clmlab-typst/Studie/task-instructions.md:65).

### 8. “Sensitivity analysis” does not adequately describe the reported bootstrap procedure

**Priority: medium.** Locations: [nice-to-have goals](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:287), [fixed-effects plots](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:349), [goal table](/Users/julian/repos/github.com/building-from-source/clmlab-typst/design-goals.typ:41).

The only described output is bootstrap 95% confidence intervals. That is uncertainty estimation; “sensitivity analysis” suggests an additional investigation of how results change under alternative assumptions or analysis choices, which is not explained.

**Suggested action:** use “bootstrap confidence intervals” consistently unless there is a separate sensitivity procedure to describe. State the bootstrap type, resampling unit, number of replicates, interval method, and treatment of failed fits. For mixed models, explain how the dependence between observations is handled. Define what plotted probabilities are conditional on or averaged over, and whether random effects are set to zero, estimated for existing groups, or integrated out.

### 9. “Design and Implementation” needs an actual implementation account

**Priority: medium.** Location: [Chapter 5](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:241).

The chapter provides design rationale and an interface walkthrough, but little explanation of implementation. Important omissions include the client/server/R workflow, package versions, supported random-effect structures, predictor contrasts, how interactions are specified, and how the generated explanations and diagnostic messages are produced.

The variable profiler, summary generator, live chatbot, and prepared study interpretations are distinct uses of an LLM. Only the chatbot's context is described in detail. The statement about sending no raw observations to OpenAI appears in that subsection, leaving its applicability to profiling unclear.

**Suggested action:** add a compact architecture and statistical-processing subsection, then separate the LLM components by purpose and inputs. Give the implementation version or repository reference where available. Explain the proportional-odds diagnostic for CLMMs specifically: the documented `ordinal::nominal_test` method operates on CLM objects, so any CLMM check or approximation needs its own description. [ordinal documentation](https://cran.r-project.org/web/packages/ordinal/ordinal.pdf)

Replace “whether the model satisfies” the proportional-odds assumption with wording about what the diagnostic detected. A check that does not reject an assumption does not establish that it holds.

## Chapter fit and narrative

Most material is in the right chapter. The main problem is missing explanation and uneven depth rather than widespread misplacement.

| Chapter | Assessment and suggested change |
| --- | --- |
| Introduction | Appropriate motivation, but add citations to the opening empirical claims and state the central evaluation question or contributions explicitly. “Promising” is less informative than a short summary of the mixed accuracy results. |
| Background | Correct role, but too brief for the later argument. Add a short explanation of logit links, thresholds/proportional odds, reference levels, interactions versus simple effects, and predicted probabilities. Expand HCI and LLM at first use. |
| Related Work | The literature summaries fit. Add a clear closing statement of the gap addressed by this project. Consider focused prior work on helping users interpret statistical output or LLM explanations; the current coverage is almost entirely statistical methodology. The timing explanation for omitting Sarma's plots could move to design scope or Future Work. |
| Related Software | Fits as an exploratory comparison that motivates design goals. Give versions, modules, dataset, and analysis paths. Describe usability implications as design judgments unless evaluated with users. |
| Design and Implementation | Design goals and workflow fit. Add implementation details as above. The rejected predictor-coding approach fits here, but define the retained ordinal coding and explain concretely what became harder to interpret. |
| User Study | Appropriate methods/results separation. Describe materials, allocation, measurement anchors, and analysis choices before the results. Move the design of the simple-effects and probability displays here from the Discussion. |
| Discussion | Keep interpretations of the results and their relationship to the design goals. Add the item-level findings and the mismatch in the prepared interpretation. Treat possible benefits of particular plots as hypotheses because the study varied text, plots, and interface together. |
| Limitations | Correctly addresses student sampling, scenario differences, prepared interpretations, and closed questions. Add material discrepancies, unknown external-aid use, and the limits of descriptive comparisons. |
| Future Work | Appropriate content, but prioritize the follow-ups that directly address the study's findings. The report would benefit from a brief conclusion stating the contribution and the limited evidence for it; it currently ends with a feature list. |
| Appendix | Appropriate place for original stimuli, scripts, and questionnaire material. Add the full task questions and scoring key, and clarify which artifacts were reconstructed. |

Keeping Discussion, Limitations, and Future Work as separate chapters is defensible. Combining them would also be reasonable given their short lengths; this is an editorial choice, not a correctness issue.

## Citation audit

### Missing or insufficient support

- **Introduction:** cite the existing Liddell/Kruschke and Syiem/Velloso sources next to the claims about misleading metric analyses and limited ordinal-model adoption. Citations later in the report do not clearly support the introduction for a reader encountering those claims first. [Location](/Users/julian/repos/github.com/building-from-source/clmlab-typst/main.typ:93)
- **Datasets:** cite provenance in each scenario and identify adaptations, as discussed in finding 3.
- **Software observations:** screenshots are legitimate evidence for direct observations. They need version/module context more than additional generic citations. The JASP QML reference documents a reusable component property, with an explicit condition that its list type be `JASP.Interaction`; it does not independently establish the behavior of every JASP analysis. Scope the claim to the observed analysis. [JASP guide](https://github.com/jasp-stats/jasp-desktop/blob/development/Docs/development/jasp-qml-guide.md)
- **Own implementation and design intentions:** these do not each require an external paper. They need implementation detail, an artifact reference, or wording that makes clear they are design hypotheses. In particular, the intention to discourage significance-seeking model changes is not an evaluated outcome.

### Bibliography corrections

1. **Christensen is misrepresented as a journal article.** The entry uses `Submitted in J. Stat. Software`, volume 35, and pages 1-46. The current source explicitly says it is no longer submitted to that journal. Cite the actual vignette/manuscript version with its URL; establish the date of the version used rather than retaining unsupported journal metadata. [Entry](/Users/julian/repos/github.com/building-from-source/clmlab-typst/bibliography.bib:87), [source](https://cran.r-project.org/web/packages/ordinal/vignettes/clm_article.pdf).
2. **The rendered ordinal citation loses essential fields.** The BibTeX contains a version and URL, but the compiled bibliography shows only author and title. Adjust the entry type or bibliography style so the version and retrieval information render. The cited version 2026.7-26 exists in the current [CRAN manual](https://cran.r-project.org/web/packages/ordinal/ordinal.pdf); separately identify the version actually used in the application and study. [Entry](/Users/julian/repos/github.com/building-from-source/clmlab-typst/bibliography.bib:43).
3. **Pin mutable documentation when feasible.** The JASP guide links to the development branch. A commit-specific reference would make the observation easier to reproduce. For undated documentation, distinguish access year from an established publication year.

### Checks that passed

- The 68-article finding and the account of possible Type I/II errors and effect reversals are supported by [Liddell and Kruschke](/Users/julian/repos/github.com/building-from-source/clmlab-typst/references/liddell-kruschke-2018-analyzing-ordinal-data.pdf).
- The 94-paper sample and counts of two CLM analyses and eight CLMM analyses agree with [Syiem and Velloso](/Users/julian/repos/github.com/building-from-source/clmlab-typst/references/syiem-velloso-2026-ordinal-regression-hci.pdf). The report correctly describes these as analyses rather than numbers of distinct papers.
- The random-effects explanation is consistent with [Taylor and colleagues](/Users/julian/repos/github.com/building-from-source/clmlab-typst/references/taylor-2023-rating-norms-clmm.pdf).
- The description of modified CCDF plots follows [Sarma's paper](/Users/julian/repos/github.com/building-from-source/clmlab-typst/references/sarma-2026-adapting-ccdf-plots.pdf).
- The claims about [JASP R Syntax Mode](https://jasp-stats.org/2023/03/06/r-syntax-mode-in-jasp-the-first-button/), [jamovi R Syntax Mode](https://docs.jamovi.org/usermanual/um_6_jamovi_and_R.html), and [jamovi level labels](https://docs.jamovi.org/data/data_1_overview_data_variables.html#adding-labels-to-levels) are supported by the cited documentation.
- The recommendation to choose plausible interactions carefully is supported by [Harrell and colleagues](https://jhanley.biostat.mcgill.ca/c681/alr_4/harrell_a.pdf), particularly printed page 363. It does not establish the usability consequences of JASP's defaults.

## Terminology and presentation

| Current usage | Suggested convention |
| --- | --- |
| `CL(M)Ms` in Related Work; `CLM(M)s` elsewhere | Choose one collective notation and define it. Retain `CLM` and `CLMM` when referring to a specific model. |
| Title `CLM(M)-tool`; study label `CLM tool` | Define one product name and one stable study-condition label. If retaining `CLM tool`, explain that the condition includes CLMM results. |
| RStudio, RStudio output, RStudio with optional LLM assistance | Define the condition once as pre-fitted R output in RStudio with permitted aids, then use the same short label throughout. |
| Sensitivity analysis | Use bootstrap confidence intervals if that is the implemented procedure. |
| Model health | Use model diagnostics in prose; retain “Health Details” when naming the interface section. |
| Two random intercepts | Use two random-intercept terms or crossed random intercepts for students and instructors. There are multiple group-specific intercepts. |
| Usability/user-friendliness | Describe the main-study measure as a single comparative rating of perceived user-friendliness. Broader usability evidence comes from the pilot. |
| Understanding | Keep self-rated understanding distinct from scored task accuracy. The report mostly already does this well. |
| Some statistical experience but little/no statistical background | “Some experience using statistical analyses but limited formal statistical training” would make the intended audience clearer. |

Additional presentation fixes:

- Remove the informal German sciebo footnote from [the appendix](/Users/julian/repos/github.com/building-from-source/clmlab-typst/appendix.typ:79). The factual explanation that the original output was unavailable is sufficient.
- Remove draft word counts from chapter headings, running headers, and footers for submission unless required.
- The long interface screenshots, especially Figure A.2, make interpretation text very small on the printed page. Split important panels or transcribe the exact study interpretations into searchable text, while preserving the full screenshots as supplementary artifacts.
- Add n = 95 to Figure 6.3 and make its caption describe the anchors for all three comparative judgments, rather than calling all of them preference measures.
- Format chart values consistently if showing one decimal place; Figure 6.2 currently displays `5` alongside `6.7` and `7.9`.
- The title page prints a slash for the second examiner. Confirm whether the template should omit that field instead.

## Suggested revision order

1. Establish the provenance of the study screenshots and resolve findings 1-3. Record any historical discrepancies as limitations.
2. Complete the study-materials, participant-flow, and implementation descriptions. Add variability and item-level results.
3. Correct citations and terminology, move display descriptions into Methods, and finish with a short conclusion and presentation cleanup.
