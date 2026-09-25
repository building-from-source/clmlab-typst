# Study analysis materials

- `task-instructions.md` transcribes the supplied questionnaire screenshots
  documenting the simple scenario, the 30-minute familiarization instructions,
  and the permitted aids in each condition. It also records the author's
  clarification that external LLM use was permitted in both conditions.
- `fit_simple_model_recreation.R` is a basic recreation of the unavailable
  simple-scenario fitting script. It uses the archived dataset and documented
  model specification and is expected to accurately reproduce the original
  analysis.
- `simple_fit_model_output.txt` was regenerated with that recreation. It replaces
  an unusable export containing only `[object Object]` and is not the original
  output shown during the study.
- `fit_model.R` and `complex_fit_model_output.txt` are the original
  complex-scenario fitting script and saved model summary.
- `derive_subsample.R` documents how the complex-scenario dataset was sampled.
- `data/ologit_data.csv` is copied from `Auswertung/ologit_data.csv`.
- `data/insteval_subsample.csv` is the supplied complex-scenario dataset,
  relocated into the directory expected by the original script.

Run the fitting scripts from this directory with R and the `ordinal` package
installed:

```sh
cd Studie
Rscript --vanilla fit_simple_model_recreation.R
Rscript --vanilla fit_model.R
```

The saved complex-scenario output contains the model summary; the original
script also prints exponentiated coefficients and random-effect variances.
The subsampling script additionally requires `lme4` and writes the complex
dataset in `data/`; it is not needed to fit either model using the saved data.
