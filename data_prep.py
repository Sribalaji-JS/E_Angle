import pandas as pd
import json

def prep_data():
    input_file = '_Project IV Angle.xlsx'
    output_file = 'EAngle_data.csv'
    
    print(f"Reading {input_file}...")
    try:
        # Load the excel file
        df = pd.read_excel(input_file)
        
        # Display raw columns
        print("Raw Columns:", df.columns.tolist())
        
        # Quick clean up: strip whitespaces and replace spaces with underscores for column names
        df.columns = df.columns.str.strip()
        
        # Drop completely empty rows or columns if any exist
        df.dropna(how='all', inplace=True)
        df.dropna(axis=1, how='all', inplace=True)
        
        # Save as CSV
        df.to_csv(output_file, index=False)
        print(f"\nSuccessfully converted to {output_file}")
        
        # Basic EDA Info
        print(f"Shape: {df.shape}")
        print("\nHead:")
        print(df.head(2))
        print("\nValue Counts for potential target (if 'Failure' in columns):")
        for col in df.columns:
            if 'fail' in col.lower() or 'type' in col.lower() or 'mode' in col.lower():
                print(df[col].value_counts())
                
    except Exception as e:
        print(f"Error processing the file: {e}")

if __name__ == '__main__':
    prep_data()
