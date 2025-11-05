from pathlib import Path
import zipfile
import numpy as np
import pandas as pd
import textwrap
import json
import os
from langchain_openai import ChatOpenAI
from openai import OpenAI


api_key = "xxx"

client = OpenAI(api_key=api_key)

dc = pd.read_csv("gpt_byimg_all.csv")


# ------------------------------------------------------------------
# 1) Per-image descriptions + examples (add all 20 images here)
#    Use your real IDs (e.g., 1..20, or filenames, etc.)
# ------------------------------------------------------------------
image_guides = {
    1: {
        "description": "A very small infant with medical tubing is being held in a basin for washing; an adult’s hands support the baby.",
        "examples_reappraisal": [
            "This is a healthy newborn being bathed.",
            "This baby is premature. A miracle.	",
            "That baby is lucky to be alive. It looks bad but it could be worse."
        ],
        "examples_non": [
            "Oh, the baby looks like he is struggling!",
            "I feel somewhat sick looking at it."
        ]
    },
    2: {
        "description": "A man is sitting on a wooden floor against a wall, holding a syringe, with foil packets on the ground near him.",
        "examples_reappraisal": [
            "taking a nap is always a fun time.	",
            "This could be worse, he could be overdosed and dead. Maybe he needs to make better life choices.",
            "wish he had some friends to help."
        ],
        "examples_non": [
            "hopeless for this person drugs are a beast	",
            "Drug addiction is horrible on oneself and their families.",
            "This makes me feel sad and sorry for this person on drugs."
        ]
    },
    3: {
        "description": "A person with long hair is shouting or screaming with hands raised near the face under strong colored light.",
        "examples_reappraisal": [
            "If I scream loud enough, maybe I can break the ice.",
            "This could be a dream...lucid dream.",
            "This man is screaming at his favorite concert."
        ],
        "examples_non": [
            "He looks like he is tripping out. Maybe a little scared.",
            "he looks shocked, probably something happend.",
            "drowning trying to escape but cant get free"
        ]
    },  
    4: {
        "description": "A close-up of an older person’s face showing swollen skin and irritation around both eyes.",
        "examples_reappraisal": [
            "At least my right eye is better. The left will heal soon.",
            "This could be makeup from a horror movie.",
            "Hopefully he is getting the medical attention that is needed, but it looks like he can still see."
        ],
        "examples_non": [
            "He looks like he is a lot of pain, sad.",
            "this is awful, he needs help, he needs love",
            "old age is enevitable for all of us. Health problems are real	"

        ]
    },  
    5: {
        "description": "A woman with curly hair and visible bruising around one eye looks directly toward the camera.",
        "examples_reappraisal": [
            "She must be a female boxer who just won a fight.",
            "domestic violence makes me angry. Hopeful she gets out soon",
            "I think maybe this person had a trip and fall and hit her face. It does not look too bad overall."
        ],
        "examples_non": [
            "DId she get beaten I feel sad for her",
            "She is beat up. Maybe an accident.	",
            "Not sure what happened but her eye looks painful."
        ]
    },  
    6: {
        "description": "A person with short hair wearing a red sweater has cuts and bruises on the face and hands while sitting indoors.",
        "examples_reappraisal": [
            "This looks like she has been helped in a hospital from a fall.	",
            "This person looks like the victim or abuse, but they seem to be getting some kind of help wich is good",
            "This Halloween costume is interesting. "
        ],
        "examples_non": [
            "sadness for her brutal beating by a stranger",
            "Domestic violence is horrible and hard to escape.",
            "holy crap what happened to her?"
        ]
    },  
    7: {
        "description": "A child’s face partly covered in gauze bandages; another person’s hands are adjusting the bandage.",
        "examples_reappraisal": [
            "Scared but alive.",
            "This baby has been injured and they are trying to dress the wound.",
            "That kid looks hurt, but i'm glad to see someone is there to take care of him.	",
            "Hopefully this child is receiving the best treatment ever.	"
        ],
        "examples_non": [
            "The kid looks in pain and sad.	",
            "sadness for this child did a adult beat on them"
        ]
    },  
    8: {
        "description": "A man wearing a white shirt and tie has blood on his chest and face, standing in a dark environment.",
        "examples_reappraisal": [
            "This could be an actor in a horror movie scene.",
            "I think this man is having a bad day but lucky to be alive.",
            "I am hopeful this man can get help since he is alert",
            "assassination attempt, didn't work. now he's mad and coming after his assailant.",
            "Crap! I can't believe the ketchup bottle exploded like that."
        ],
        "examples_non": [
            "afraid he looks like he is on a rampage to kill",
            "I am shocked at how much blood he is losing and fearful of what happened",
        ]
    },  
    9: {
        "description": "A young man is pointing a handgun directly toward the camera.",
        "examples_reappraisal": [
            "This is a cool image actually. Nobody is hurt or injured.",
            "Looks like he intends violence. But it could be the cover of a movie.",
            "You won't do it. You don't have it in you. Look at your eyes little boy."

        ],
        "examples_non": [
            "Definitely scary and unpredictable to be faced with such anger.",
            "I would be very scared to have this pointed at me.	",
            "I imagine what it would be like to be looking at this in real life. How scared i would be"
        ]
    },  
    10: {
        "description": "A man and woman are in the back of a van; the man is grabbing the woman while she tries to resist.",
        "examples_reappraisal": [
            "This could be a self-defense video.",
            "It looks like they could be playing or fake wrestling. Maybe its not what it appears to be.",
            "Those classes paid off."
        ],
        "examples_non": [
            "angure for their life. a kidnapping",
            "aw i feel bad for them, that looks painful	",
            "No means no dude! She's not interested! I'd punch him.	"
        ]
    },  
   11: {
        "description": "A shirtless man wearing boxing gloves is being struck in the face, with droplets and blood visible around him.",
        "examples_reappraisal": [
            "fun watching a fight on tv ha",
            "I took this punch like a pro. It only hurt for a few days.",
            "It looks like a bad hit, but it looks like a planned event so they knew what the risks were for participating.	",
            "THAT WAS A REAL SLOBBER KNOCKER, J R! Ouch. 2 participants checked out	"

        ],
        "examples_non": [
            "boxing matches are exciting but scary thriller also. hurt",
            "A boxing match, but this guy is getting hurt.",
            "I feel bad for the guy getting hit, but that's boxing	"
        ]
    },
    12: {
        "description": "A person riding a bicycle is surrounded by large flames covering their body and the background.",
        "examples_reappraisal": [
            "scarey for this persons life, i hope this is a stunt",
            "Hopefully, he was wearing protective gear.	",
            "I hope he's wearing a firesuit, otherwise this is very painful and deadly.",
            "This is most likely a stunt."
        ],
        "examples_non": [
            "This is hard to look at. I can't imagine what that person feels like",
            "fire stop drop and roll get off that bike fast buddy"
        ]
    },
    13: {
        "description": "A man’s face is pressed against a piece of bamboo; a section of his tongue is wrapped around it.",
        "examples_reappraisal": [
            "This is traditional jewelry for the men of this tribe.	",
            "cultures are all unique. Possibly a traditional cerem",
            "This is strange but not really upsetting. It looks intentional"
            "Is this special effects for a movie? That takes real talent."
        ],
        "examples_non": [
            "Pain why would do this for vanity or your culture",
            "You're really stupid. Why do that to yourself?	",
            "That looks painful! And he looks like he is crying."
        ]
    },  
    14: {
        "description": "A large passenger airplane is on the ground with smoke and fire in the background, while people walk and move away from it.",
        "examples_reappraisal": [
            "Amazing, everyone survived!",
            "It looks like a plane crash. Hopefully everyone is okay and nobody died.",
            "It looks like people were able to escape from this plane. Hopefully nobody died."
        ],
        "examples_non": [
            "fear and sadness for these peoples lives",
            "plane crash are scary. reminds me of 9/11 maybe",
            "A tragedy occurred here."
        ]
    },  
    15: {
        "description": "Two people wearing protective suits and masks are walking through an area covered in fire and smoke.",
        "examples_reappraisal": [
            "This is a clean-up from a chemical fire to help",
            "At least people have protective gear and seem to be doing okay.",
            "I loved this scene from my favorite movie.	"
        ],
        "examples_non": [
            "fear of being burned up int his deadly fire",
            "This is what will kill us all. Poisonous!",
            "This looks frightening to be around"
        ]
    },  
    16: {
        "description": "A man wearing a hat is standing in a field and using a shovel to bury someone in the ground.",
        "examples_reappraisal": [
            "This is what is normal in that land.",
            "It looks like the worst is over and people are evacuating safely.",
            "I think that this could be a set and not real, but if it is I feel sad for this man. At least he can be burried.",
            "This man is saving his family the expense of a funeral."
        ],
        "examples_non": [
            "I feel fear for this man in this whole is he dead",
            "They are burying a body in a shallow grave.",
            "Burning a man alive, unmarked grave, very sad.	"
        ]
    },  
    17: {
        "description": "A man is lying motionless on a street, with two people and a couple of dogs nearby.",
        "examples_reappraisal": [
            "Did he spill his red koolaid when he fell?",
            "His family can rest now that they have seen him.",
            "They need to get him help. Maybe it was an accident."
        ],
        "examples_non": [
            "This makes me want to chug up breakfast. The dog licking the blood.",
            "Poor family and person. He was clearly murdered.",
            "Something violent has happened here. There is a lot of blood."
        ]
    },  
    18: {
        "description": "Two children with dirt on their faces and clothing are standing in front of a dark wooden fence, with industrial buildings and smoke in the background.",
        "examples_reappraisal": [
            "This could be from working to earn money.",
            "Is this war, or were they trespassing in a mine?",
            "the boys look dirty but not hurt.  lots of smoke in back"
        ],
        "examples_non": [
            "Children are always the suffers of war.",
            "this looks pretty painful and the baby looks sad",
            "I feel sad knowing these kids are going through a tough time"
        ]
    },  
    19: {
        "description": "Several emergency responders and police officers are standing near a heavily damaged car at the scene of a traffic accident.",
        "examples_reappraisal": [
            "If we work as a team, we can clean this up in no time.",
            "Maybe the passenger(s) survived.",
            "Good thing rescue workers are there and their is no body, hopefully everyone turned out okay."
        ],
        "examples_non": [
            "Horrific a terrible car accident!",
            "This gives me the chills. Looks fatal and no chance of survival."
        ]
    },  
    20: {
        "description": "Firefighters in protective gear are rescuing a person from a building, carrying them down a ladder as smoke rises from a window.",
        "examples_reappraisal": [
            "American heroes. They risk their lives",
            "The woman has been saved from sure death, this is happy",
            "firefighters face alot of stress saving people. Hero"
        ],
        "examples_non": [
            "She looks dead, they weren't able to save her in time.",
            "This is very upsetting to see. I feel terrible seeing this",
            "She looks injured. A fire is happening. "
        ]
    }
}

## define prompt
GLOBAL_CODEBOOK = {
  "M1":{
      "label": "Reappraisal",
      "description": "Cognitive reappraisal involves changing how one thinks about or interprets the situation in the picture with the goal to change one's emotions. Note that all scenes are highly negative and traumatic in nature, so any attempt to describe or reinterpret the scene in a more positive or neutral way would be considered reappraisal.",
      "examples": [
        "Maybe the bandages are showing that the child is totally healed",
        "I hope she can make it out alive",
        "This injured person has found help.",
        "This is from a movie or TV show",
        "It's a typical day.",
        "hopefully no one was hurt badly."
      ]
    },
  "M2":{
      "label": "Non-reappraisal",
      "description": "All other texts that do not show a change in how one interprets a situation to change one's emotions. An objective description of the negative scene without changing the meaning would be considered Non-reappraisal.",
      "examples": [
        "Oh my this looks terribly painful.",
        "Scary, I hope I never face that image",
        "I feel sadness that he either witnessed or just went through something traumatic.",
        "a man screaming but not sure why could be many reasons"
      ]
    },
}


def build_prompt_for_image(text: str, image_id, image_guides: dict):
    guide = image_guides.get(image_id, None)
    img_desc = guide["description"] if guide else "No specific description available."
    img_reapp = guide["examples_reappraisal"] if guide else []
    img_non = guide["examples_non"] if guide else []

    prompt = textwrap.dedent(f"""\
    You are a research assistant helping classify whether a participant is using the emotion regulation strategy "reappraisal" in their text.
    The stimuli are pictures that are designed to trigger intense negative emotions, which contain scenarios like domestic violence, street crime, murders, car accident, gun shot, fire accident, etc.
    Participants in the experimental condition were taught cognitive reappraisal and asked to use reappraisal to reduce negative emotions triggered by the photos.
    Participants in the contronl condition were asked to observe the natural emotional feelings after viewing the stimuli. 
    All participants wrote down their feelings following the experimental or control instructions after viewing each picture.

    You will be providing the definition of reappraisal and non-reappraisal, along with a global codebook and image-specific context and examples to help you classify the participant response.

    GLOBAL DEFINITIONS
    - Reappraisal: Changing how one thinks about or interprets the situation with the goal to change one's emotions.
    - Non-reappraisal: All other responses that do not change the interpretation to regulate emotion; purely descriptive or emotional reactions without reinterpretation.

    GLOBAL CODEBOOK
    {json.dumps(GLOBAL_CODEBOOK, ensure_ascii=False, indent=2)}

    IMAGE-SPECIFIC CONTEXT
    - Image description: {img_desc}

    IMAGE-SPECIFIC EXAMPLES
    - Reappraisal examples for this image:
    {json.dumps(img_reapp, ensure_ascii=False, indent=2)}
    - Non-reappraisal examples for this image:
    {json.dumps(img_non, ensure_ascii=False, indent=2)}


    PARTICIPANT RESPONSE
    "{text}"

    TASK
    Return only the category label that is exactly one of:
    - "Reappraisal"
    - "Non-reappraisal"

    Return only the label. Do not include any extra text.
    """)

    return prompt

'''
image_id = 1

prompt = build_prompt_for_image(text="hope they will get better.", image_id=image_id, image_guides=image_guides)
response = client.chat.completions.create(
    model="gpt-4o-mini",  # Or your preferred model
    messages=[
        {"role": "user", "content": prompt}
    ],
    max_tokens=150,
    temperature=0,
)
label = response.choices[0].message.content.strip()

print(label)
'''



## run the code pipeline for each row
output_path = "label_gpt_byimg_all.csv"
out_df = pd.read_csv(output_path) if os.path.exists(output_path) else pd.DataFrame()

fail_idx = []

for i, row in dc.iloc[20776:26697].iterrows():
    text = row.get("txt", "")
    image_id = row.get("img")

    if not isinstance(text, str) or not text.strip():
        continue

    try:
        prompt = build_prompt_for_image(text=text, image_id=image_id, image_guides=image_guides)

        # Ask for JSON output to simplify parsing
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[{"role": "user", "content": prompt}],
            temperature=0,
            max_tokens=150
        )

        label = response.choices[0].message.content.strip()

        rec = {
            "sub_id": row.get("sub_id"),
            "trial": row.get("trial"),
            "text": text,
            "gpt_label": label
        }
        out_df = pd.concat([out_df, pd.DataFrame([rec])], axis=0)

        # periodic flush
        if i % 25 == 0:
            out_df.to_csv(output_path, index=False)

        print(f"row {i} (image {image_id}): {label}")

    except Exception as e:
        fail_idx.append(i)
        print(f"error on row {i}: {e}")

# final save
out_df.to_csv(output_path, index=False)
print("done. failures:", fail_idx)


