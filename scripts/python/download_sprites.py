import os
import requests
import zipfile
import argparse
import multiprocessing

def download_and_extract(start_number, end_number, queue, base_url, destination_folder):
    # Define the base URL and destination folder
    # base_url = "https://spriteserver.pmdcollab.org/assets/{:04d}/sprites.zip"
    # destination_folder = "Images/SpriteCollab/sprite"

    for number in range(start_number, end_number + 1):
        # Create the destination folder if it doesn't exist
        folder_path = os.path.join(destination_folder, f"{number:04d}")
        os.makedirs(folder_path, exist_ok=True)

        # Define the URL for the current number
        zip_url = base_url.format(number)

        # Define the path to the downloaded zip file
        zip_file_path = os.path.join(folder_path, "sprites.zip")

        # Download the zip file
        response = requests.get(zip_url)

        if response.status_code == 200:
            with open(zip_file_path, "wb") as file:
                file.write(response.content)
            print(f"Zip file for {number:04d} downloaded successfully.")

            # Extract the contents of the zip file
            with zipfile.ZipFile(zip_file_path, "r") as zip_ref:
                zip_ref.extractall(folder_path)
            print(f"Zip file contents for {number:04d} extracted successfully.")

            # Delete the zip file
            os.remove(zip_file_path)
            print(f"Zip file for {number:04d} deleted.")
        else:
            print(f"Failed to download the zip file for {number:04d}.")

    # Notify the queue that the task is complete
    queue.put(True)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Download and extract zip files for a range of numbers using multiprocessing.")
    parser.add_argument("--start-number", "-s", type=int, required=True, help="Starting number")
    parser.add_argument("--end-number", "-e", type=int, required=True, help="Ending number")
    parser.add_argument("--num-processes", "-j", type=int, default=-1, help="Number of processes to use (default: -1)")
    parser.add_argument("--base-url", "-b", default="https://spriteserver.pmdcollab.org/assets/{:04d}/sprites.zip", type=str, help="Base URL for downloading")
    parser.add_argument("--destination-folder", "-d", default="Images/PokemonSprites", type=str, help="Destination folder for the downloaded files")
    
    args = parser.parse_args()

    

    # Create a queue to coordinate the processes
    queue = multiprocessing.Queue()

    # Calculate the range of numbers to distribute among processes
    num_processes = args.num_processes
     # Determine the number of CPU cores if num-processes is -1
    base_url = args.base_url
    destination_folder = args.destination_folder
    if args.num_processes == -1:
        num_processes = multiprocessing.cpu_count()
    else:
        num_processes = args.num_processes

    numbers_per_process = (args.end_number - args.start_number + 1) // num_processes

    # Create and start the processes
    processes = []
    for i in range(num_processes):
        start = args.start_number + i * numbers_per_process
        end = start + numbers_per_process - 1 if i < num_processes - 1 else args.end_number
        process = multiprocessing.Process(target=download_and_extract, args=(start, end, queue, base_url, destination_folder))
        processes.append(process)
        process.start()

    # Wait for all processes to complete
    for process in processes:
        process.join()

    # Check the queue for completion signals
    for _ in range(num_processes):
        queue.get()

    print("All processes have completed.")
