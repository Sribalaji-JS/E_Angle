import pandas as pd
import sys
import re

def convert():
    xl = pd.ExcelFile('_Project IV Angle Final.xlsx')
    data = []
    
    for sheet in xl.sheet_names:
        if 'SP 6' in sheet: continue
        # Extract Nr from sheet name if present
        nr = None
        match = re.search(r'Nr=(\d)', sheet)
        if match:
            nr = int(match.group(1))
            
        df = pd.read_excel(xl, sheet_name=sheet)
        if df.shape[0] > 0 and str(df.iloc[0].get('A', '')) == 'mm':
            df = df.iloc[1:].copy()
        
        # Rename Failure
        for c in df.columns:
            if str(c).strip().lower() == 'failure':
                df.rename(columns={c: 'Failure'}, inplace=True)
            if str(c).strip().lower() == 'designation':
                df.rename(columns={c: 'Designation'}, inplace=True)
            if str(c).strip().lower() == 'capacity':
                df.rename(columns={c: 'capacity'}, inplace=True)

        for _, row in df.iterrows():
            desig = str(row.get('Designation', '')).strip()
            if not desig or desig == 'nan': continue
            
            try:
                A = float(row.get('A', 0))
                B = float(row.get('B', 0))
                t = float(row.get('t', 0))
                n = int(float(row.get('n', 0)))
                d = float(row.get('d', 0))
                dh = float(row.get('dh', 0))
                p = float(row.get('p', 0))
                e = float(row.get('e', 0))
                cap = float(row.get('capacity', 0))
            except Exception as e:
                continue
                
            fail = str(row.get('Failure', ''))
            
            rnr = nr if nr is not None else 0
            
            data.append({
                'designation': desig, 'A': A, 'B': B, 't': t, 'n': n, 'd': d, 'dh': dh, 'p': p, 'e': e,
                'capacity': cap, 'failure': fail, 'Nr': rnr
            })
            
    out_df = pd.DataFrame(data)
    out_df.to_csv('EAngle_data.csv', index=False, encoding='utf-8')
    print("Done converting {} rows.".format(len(data)))

convert()
