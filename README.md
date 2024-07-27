# SerpAPI Code Challenge

## 👋 Introduction

This project has a script file `main.rb` that sets some variables that are used to run the example:

- `path_to_json_result`: This variable holds the path where the expected arrays will be saved upon each website is scrapped. By default it's set to `./expected_arrays`, which is in the same directory of the project.

- `serp_api_challenge_link`: This is the link provided in the challenge that needs to be scrapped to generate the json output and json file.

- `bing_link`: This is the first extra web address out of the 2 asked in the challenge. This is a Bing link for the search "Leonardo da Vinci paintings".

- `google_link`: This is the second extra web address for the challenge. This is a Google link for the search "claude monet paintings".

After these variables, each website is scrapped and generate a json file with the result at their respective `result_path` inside the folder defined in `path_to_json_result`

By default,
`SiteFormat::SerpApiChallenge` will generate a json file at `./expected_arrays/serp_api.json`, 
`SiteFormat::Bing` will generate a json file at `./expected_arrays/bing.json`, and
`SiteFormat::Google` will generate a json file at `./expected_arrays/google.json`.

## 🤔 Strategy

Since scrapping each website involves a lot of repetition, I have decided to create a Parent Class `SiteFormat::SiteStructure` that holds all the common scrapping logic that the other classes `SiteFormat::SerpApiChallenge`, `SiteFormat::Bing`, `SiteFormat::Google` inherits from. </br>
Each child Class must define their instance variables that have the css classes needed for them to find the elements of interest in each page. </br>
Other than that, when a Child Class needs to do something different from the Parent Class, they override the Parent Class methods to suit their unique needs.

## 🛠️ Setup

This project requires ruby version `3.2.1` installed.

Install gems:
```
bundle install
```

Run the `main.rb` script to generate the results:
```
ruby main.rb
```

As the script run, it will print the following messages on the terminal (if all variables are kept with their default values):
```
JSON file from https://raw.githubusercontent.com/serpapi/code-challenge/master/files/van-gogh-paintings.html
Created at: ./expected_arrays/serp_api.json

JSON file from https://www.bing.com/search?q=Leonardo+da+Vinci+paintings&form=QBLH&sp=-1&ghc=2&lq=0&pq=leonardo+da+vinci+paintings&sc=10-27&qs=n&sk=&cvid=68B9840A12034429B78D07B9A775AD1E&ghsh=0&ghacc=0&ghpl=
Created at: ./expected_arrays/bing.json

JSON file from https://www.google.com/search?q=claude+monet+paintings&sca_esv=53114e91519e1d18&sxsrf=ADLYWILH6eITGfJVb_-oMrwGEjpoUl0y0g%3A1721957729830&source=hp&ei=Yf2iZrLnL8miptQPifOz0Ao&iflsig=AL9hbdgAAAAAZqMLcentss0hb4MKFq4bBmctQQ85aisV&ved=0ahUKEwjym7W2yMOHAxVJkYkEHYn5DKoQ4dUDCBc&uact=5&oq=claude+monet+paintings&gs_lp=Egdnd3Mtd2l6IhZjbGF1ZGUgbW9uZXQgcGFpbnRpbmdzMggQABiABBixAzIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyBRAAGIAEMggQABiABBjJA0iZClDPBFjPBHABeACQAQCYAW2gAW2qAQMwLjG4AQPIAQD4AQL4AQGYAgKgAnioAgrCAgcQIxgnGOoCmAMIkgcDMS4xoAfhBQ&sclient=gws-wiz
Created at: ./expected_arrays/google.json
```

Now all the expected array json files are created at `./expected_arrays` folder.

## 🧪 Testing

There are 3 spec files in `./spec/site_format` folder:
- `bing_spec.rb`
- `google_spec.rb`
- `serp_api_challenge_spec.rb`

They test whether the results output from the scrappers are correct, and finally, they test whether each scrapper can generate a json file at their given folder (for specs they're saved at `./spec/tmp` folder). These files are deleted right after the spec is run to cleanup.

Though I could have used shared_examples to keep the specs DRY, I decided not to do that for clarity, and to make them easier to analyze.

Each spec has their own template file located at `./spec/support/templates`:
- `bing_template.html.erb`
- `google_template.html.erb`
- `serp_api_challenge_template.html.erb`

These templates have the same css classes that are found in the real websites for each scrapper.
They get populated at spec run with dynamic data created by the `Faker` gem.

Run Specs:
```
rspec
```

## 💪 Challenge

The biggest challenge I found during this exercise was the fact that there's a javascript script in the file from the link provided that find some of the `<img>` tags in the file based on their `id` and replace their `src` attribute with another value.
I couldn't get those scripts to run using a webdriver, so I decided to use a regex to match the values in the file in order to generate the result with the correct values.

## 📽️ Video Demo

This Demo video goes over each file of the project, explaining my thought process for each step and it also shows how to run the project and specs. However, it does not go over the setup section of this README file.

[![SerpAPI Challenge - Solution Demo](https://img.youtube.com/vi/lKTGswsvi-8/0.jpg)](https://youtu.be/lKTGswsvi-8)