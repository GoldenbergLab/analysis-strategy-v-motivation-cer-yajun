from pathlib import Path
import zipfile
import numpy as np
import pandas as pd
import textwrap
import os
api_key = "xxx"
client = ChatOpenAI(temperature=0,
                   model='gpt-4o-mini',
                   openai_api_key=api_key,
                   logprobs=True)

# Set the directory path
folder_path = Path(r'xx')

## now handle the differen types of USE
dc = pd.read_csv()

## define prompt
codebook_type_of_use = {
  "M1":{
      "label": "Reappraisal",
      "description": "Cognitive reappraisal involves changing how one thinks about or interprets the situation in the picture with the goal to change one's emotions.",
      "examples": [
        "Maybe the bandages are showing that the child is totally healed",
        "Looks like she made it out alive",
        "This injured person has found help.",
        "These toy guns look pretty real nowadays",
        "This man looks like a good actor, I am interested in seeing this movie."
      ]
    },
  "M2":{
      "label": "Non-reappraisal",
      "description": "All other texts that do not show a change in how one interprets a situation to change one's emotions.",
      "examples": [
        "Oh my this looks terribly painful.",
        "Scarey, I hope I never face that image",
        "I feel sadness that he either witnessed or just went through something traumatic.",
        "This seems like a war injury, from an explosion. I feel a loss for this child's childhood. So tragic.",
        "The person needs help. They are on drugs."
      ]
    },
 #....
}

def _get_prompt_classify_motivation(theme_codebook, text):
    prompt_21 = textwrap.dedent(f"""\
You are a research assistant helping with a thematic analysis of survey responses. 
We want to classify whether people are using an emotion regulation stratgy called reappraisal or not in their text responses to stimuli.
The stimuli are pictures that are designed to trigger intense negative emotions, which contain scenarios like domestic violence, street crime, murders, car accident, gun shot, fire accident, etc.
Participants in the experimental condition were taught cognitive reappraisal and asked to use reappraisal to reduce negative emotions triggered by the photos.
Participants in the contronl condition were asked to observe the natural emotional feelings after viewing the stimuli. 
All participants wrote down their feelings following the experimental or control instructions after viewing each picture.

You are given:
1. A codebook of categories (with labels, descriptions, and examples).
2. A short text response from a participant describing their feeling.

Your task:
- Read the participant response carefully.
- Assign either Reappraisal or Non-reappraisal label to the text from the codebook according to the definiiton. 
- For the output: return only the category label (must be "Reappraisal" or "Non-reappraisal").  
- Do not include explanations, formatting, or text other than the label(s).

Codebook:
{theme_codebook}

Survey response:
"{text}"

Now please output the assigned label(s):
""")

    return prompt_21



## run the code pipeline for each row
fail_m_l = []
output_path_mot = folder_path / 'motivation_class_step1_rep2_0820.csv'

if os.path.exists(output_path_mot):
    r1 = pd.read_csv(output_path_mot)
else:
    r1 = pd.DataFrame()

for i, row in dc.iloc[0:50].iterrows():
    extractive = row['xx']

    try:
        if str(extractive) != 'nan':
            prompt = _get_prompt_classify_motivation(text=extractive)
            response = self_consistency_gen(prompt=prompt, model=client, num_iterations=5)

            res = {
                'UID': row['UID'],
                'smu_intention_text': extractive,
                'label_motivation_step1': response[0].content
            }
            res_df_tmp = pd.DataFrame([res])
            r1 = pd.concat([r1, res_df_tmp], axis=0)
            r1.to_csv(folder_path / output_path_mot, index=False)

            print(f'done for row {i}')

    except:
        fail_m_l.append(i)
        print(f'error for row {i}')



