import json
import csv
import re

def extract_and_convert():
    html_file = 'EAngle.html'
    csv_file = 'EAngle_data.csv'
    
    with open(html_file, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Find the JSON array
    match = re.search(r'const ANGLE_DATA \=\ (\[\{.*?\}\]);', content, re.DOTALL)
    if not match:
        print("Data not found in HTML.")
        return
        
    data_json_str = match.group(1)
    
    data = json.loads(data_json_str)
    
    if not data:
        print("No data extracted.")
        return
        
    # Get headers from first dict
    headers = list(data[0].keys())
    
    with open(csv_file, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        writer.writerows(data)
        
    print(f"Successfully extracted {len(data)} rows to {csv_file}")
    
if __name__ == "__main__":
    extract_and_convert()
