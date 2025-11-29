# analysis-r-strategy-vs-motivation-study 1

<!-- toc -->
- [Purpose](#purpose)

<!-- tocstop -->

## Purpose

The goal of this paper is to study how two important aspects of ER, strategy and motivation, contribute to the success of regulating group emotions. 

## Update 2025/11: Notes on the GPT classifier codes
The codes for GPT labeling and analysis can be found within the "analysis" folder. 

Here's an overview of what we did for GPT labeling:

We trained an LLM model (GPT 4o-mini) to classify whether the participants’ text responses to a given image are a cognitive reappraisal or not. In the training, we first provided the LLM model with definitions of reappraisal (“Changing how one thinks about or interprets the situation with the goal to change one's emotions.”) and non-reappraisal as the guiding criteria of classification.

Then, we further provided image-specific prompts. For each picture, we provided a brief, objective statement that helps the model understand what the picture shows without implying emotion or evaluation. We also selected 3-5 typical responses of reappraisal and non-reappraisal per image, respectively, from the first 10 responses of each image in the data. 

Each response was classified by the model independently with the image-specific prompts.

To validate the accuracy of the model classification, we manually labeled the first 15 responses for each image using the same criteria (i.e., 300 manually-labeled texts in total). It’s possible that we overestimated the agreement because the reappraisal examples we provided to the model also came from the first 10 responses. Thus, as a more conservative test, we only looked at the sample of the 11th-15th responses for each image, and again found a high agreement there, accuracy = 91.0%, Cohen's kappa = 0.73. 

