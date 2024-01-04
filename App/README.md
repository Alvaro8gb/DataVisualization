

## Dataset

The dataset if from UCI [LINK](https://archive.ics.uci.edu/dataset/503/hepatitis+c+virus+hcv+for+egyptian+patients),
contains information about Hepatitis C Virus (HCV) for Egyptian patients, dont have missing values.


| Variable Name               | Role    | Type    | Description                       |
|-----------------------------|---------|---------|-----------------------------------|
| Age                         | Feature | Integer |                                   |                                            
| Gender                      | Feature | Binary  | [Male], [Female]                  |                                            
| BMI                         | Feature | Integer |  Body Mass Index                  |
| Fever                       | Feature | Binary  | [Absent], [Present]               |                                            
| Nausea/Vomiting             | Feature | Binary  | [Absent], [Present]               |                                            
| Headache                    | Feature | Binary  | [Absent], [Present]               |                                            
| Diarrhea                    | Feature | Binary  | [Absent], [Present]               |                                            
| Fatigue & generalized bone ache | Feature | Binary  | [Absent], [Present]           |                                            
| Jaundice                    | Feature | Binary  | [Absent], [Present]               |                                            
| Epigastric pain             | Feature | Binary  | [Absent], [Present]               |                                            
| WBC                         | Feature | Integer | White blood cells                 |
| RBC                         | Feature | Integer | Red blood cells                   |
| HGB                         | Feature | Integer | Hemoglobin                        |
| Plat                        | Feature | Integer | Platelets                         |
| AST 1                       | Feature | Integer | aspartate transaminase ratio      |                      
| ALT 1                       | Feature | Integer | alanine transaminase ratio 1 week |                    
| ALT4                        | Feature | Integer | alanine transaminase ratio 4 weeks |                   
| ALT 12                      | Feature | Integer | alanine transaminase ratio 12 weeks |                  
| ALT 24                      | Feature | Integer | alanine transaminase ratio 24 weeks |                  
| ALT 36                      | Feature | Integer | alanine transaminase ratio 36 weeks |                  
| ALT 48                      | Feature | Integer | alanine transaminase ratio 48 weeks |                  
| ALT after 24 w              | Feature | Integer | after 24 warnings alanine transaminase ratio 24 weeks | 
| RNA Base                    | Feature | Integer |                        |                                
| RNA 4                       | Feature | Integer |                        |                                
| RNA 12                      | Feature | Integer |                        |                                

## Intall dependencis



```bash
Rscript dependencies.R 
```

## Lunch App

```bash
cd app
chmod +x launch.sh
./launch.sh
```