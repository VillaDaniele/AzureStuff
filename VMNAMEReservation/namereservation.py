import csv
import os

csv_file_path = "/home/runner/work/AzureStuff/AzureStuff/csv/azurevmnames.csv"

# Leggi i nomi delle VM attuali dal file CSV
with open(csv_file_path, mode='r') as file:
    reader = csv.DictReader(file)
    current_azure_vm_names = [row['VMNAME'] for row in reader]

# Ottieni l'ultimo nome della VM dal file CSV
latest_azure_vm_name = current_azure_vm_names[-1]

# Estrai il numero dall'ultimo nome della VM
next_available_vm_number = int(latest_azure_vm_name[-3:])

# Calcola il prossimo nome della VM
next_vm_name = f"{latest_azure_vm_name[:5]}{next_available_vm_number + 1}"

# Controlla se il prossimo nome della VM è già presente
if next_vm_name in current_azure_vm_names:
    print("The operation failed.")
else:
    print("The next available name for a Virtual Machine is:", next_vm_name)
    
    # Aggiungi il nuovo nome della VM al file CSV
    with open(csv_file_path, mode='a', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['VMNAME'])
        writer.writerow({'VMNAME': next_vm_name})
