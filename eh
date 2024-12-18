from random import randint
from cmu_graphics import *
import math
import time
import random
import webbrowser
from datetime import datetime, timedelta


'''buttons: https://www.phidgets.com/education/learn/projects/cmu/buttons/?srsltid=AfmBOopq78AEcTceXhBgQMzNwUfMEGGskvjCyyer78G-UEe3TB1C_-T_'''
WIDTH, HEIGHT = 1200, 800
WAVE_COUNT = 7
WAVE_SPEED = 2
WAVE_HEIGHT = 30
WAVE_SPACING = 40
WAVE_COLORS = [
    (70, 130, 180), (95, 158, 160), (100, 180, 200),
    (135, 206, 235), (176, 224, 230), (173, 216, 230), (200, 240, 255)
]
BUTTON_WIDTH, BUTTON_HEIGHT = 200, 50
BEACH_HEIGHT = 150
STARFISH_COUNT = 8
STARFISH_COLORS = ["orange", "yellow", "red", "pink"]
SKY_GRADIENT = [(135, 206, 235), (173, 216, 230)]
MOOD_DATA = [6, 7, 8, 5, 9]  # Example mood data for graphs

# Globals
'''https://www.crisistextline.org/blog/2024/01/08/100-positive-affirmations-for-better-self-care/'''
wave_offsets = [i * 60 for i in range(WAVE_COUNT)]
starfish_positions = []
current_screen = "menu"
affirmations = [
    # Calm and Peace
    "I am calm, centered, and in control of my emotions.",
    "Each deep breath brings me closer to inner peace.",
    "I am safe, I am calm, and I trust the journey.",

    # Gratitude
    "I am grateful for the good things in my life.",
    "Every day, I find reasons to be thankful.",
    "Gratitude fills my heart and uplifts my spirit.",

    # Self-Love
    "I am worthy of love and kindness.",
    "I accept myself just as I am.",
    "My body, mind, and spirit deserve respect and care.",

    # Motivation and Growth
    "I am capable of achieving my goals.",
    "Each day, I am improving and growing.",
    "I am resilient, strong, and brave.",

    # Stress Relief
    "I release all tension and embrace relaxation.",
    "I let go of what I cannot control.",
    "I deserve rest and renewal.",

    # Focus and Clarity
    "My mind is clear, and I am focused on my purpose.",
    "I trust my intuition to guide me.",
    "I approach challenges with confidence and clarity.",

    # Healing
    "I am healing, and every cell in my body is working for my health.",
    "I let go of past hurts and embrace the present moment.",

    # Abundance
    "I attract positivity, abundance, and joy.",
    "Opportunities flow into my life effortlessly.",
    "I am open to receiving all the good the universe has to offer.",

    # Relationships
    "I nurture meaningful and supportive relationships.",
    "I am surrounded by love and positive energy.",
    "I communicate with clarity and compassion.",

    # Empowerment
    "I am powerful, and I create the life I want.",
    "I trust in my ability to overcome challenges.",
    "I am proud of the progress I’ve made."
]
word_frequency = {"peace": 10, "calm": 8, "focus": 5}  # Example word frequency

'''https://www.youtube.com/watch?v=RB6L9Amx6dY'''
# Initialize starfish positions
def initialize_starfish_positions():
    """Randomly position starfish on the beach."""
    global starfish_positions
    starfish_positions = [
        (randint(50, WIDTH - 50), HEIGHT - BEACH_HEIGHT + randint(-10, 10), STARFISH_COLORS[i % len(STARFISH_COLORS)])
        for i in range(STARFISH_COUNT)
    ]

# Helper Functions
'''https://stackoverflow.com/questions/25668828/how-to-create-colour-gradient-in-python'''
def draw_gradient_background(app):

    """Draw a blended gradient background for the sky."""
    gradient = [(25, 25, 112), (70, 130, 180)] if app.night_mode else SKY_GRADIENT
    
    for i in range(HEIGHT - BEACH_HEIGHT):
        ratio = i / (HEIGHT - BEACH_HEIGHT)
        r1, g1, b1 = gradient[0]
        r2, g2, b2 = gradient[1]
        blended_color = rgb(
            int(r1 * (1 - ratio) + r2 * ratio),
            int(g1 * (1 - ratio) + g2 * ratio),
            int(b1 * (1 - ratio) + b2 * ratio),
        )
        drawLine(0, i, WIDTH, i, fill=blended_color)

'''https://www.youtube.com/watch?v=ZKvgFcAcfog'''
def update_waves():
    """Update wave offsets for animation."""
    for i in range(len(wave_offsets)):
        wave_offsets[i] += WAVE_SPEED
        if wave_offsets[i] >= 360:
            wave_offsets[i] -= 360

def draw_waves():
    """Draw smooth animated waves."""
    for layer, offset in enumerate(wave_offsets):
        color = rgb(*WAVE_COLORS[layer % len(WAVE_COLORS)])
        for x in range(-50, WIDTH + 50, 50):
            y = HEIGHT - BEACH_HEIGHT - layer * WAVE_SPACING + math.sin(math.radians(x + offset)) * WAVE_HEIGHT
            drawCircle(x, y, 30, fill=color, border=None)

def draw_beach():
    """Draw the static beach at the bottom with starfish."""
    drawRect(0, HEIGHT - BEACH_HEIGHT, WIDTH, BEACH_HEIGHT, fill="sandybrown")
    for x, y, color in starfish_positions:
        draw_starfish(x, y, 20, color)

def draw_starfish(x, y, size, color):
    """Draw a starfish without a border."""
    points = [
        (x, y - size),
        (x + size * 0.3, y - size * 0.3),
        (x + size, y - size * 0.3),
        (x + size * 0.4, y + size * 0.1),
        (x + size * 0.5, y + size),
        (x, y + size * 0.5),
        (x - size * 0.5, y + size),
        (x - size * 0.4, y + size * 0.1),
        (x - size, y - size * 0.3),
        (x - size * 0.3, y - size * 0.3),
    ]
    drawPolygon(*sum(points, ()), fill=color, border=None)

def draw_menu(app):
    """Draw the main menu with light blue buttons."""
    drawLabel("Welcome to the Meditation App", WIDTH // 2, 50, size=36, fill="black", bold=True)
    
    # Meditation button
    drawRect(100, 150, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Meditate", 200, 175, size=24)
    
    # Journal button
    drawRect(100, 225, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Journal", 200, 250, size=24)
    
    # Mood Graph button
    drawRect(100, 300, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Mood Graph", 200, 325, size=24)
    
    # Hours Meditated button
    drawRect(100, 375, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Hours Meditated", 200, 400, size=24)
    
    # Affirmations button
    drawRect(100, 450, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Affirmations", 200, 475, size=24)
    
    # Most Frequent Words button
    drawRect(100, 525, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Word Cloud", 200, 550, size=24)

    # Calendar Button
    drawRect(100, 600, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Calendar", 200, 625, size=24)

    # Night/Day Mode Button
    drawRect(1000, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel(app.mode_label, 1075, 75, size=18, fill="black")

    drawRect(100, 675, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("Pomodoro Timer", 200, 700, size=24)

    # Set Goal Button (Next to Night Mode)
    drawRect(1000, 150, 150, 50, fill="lightgrey", border="black")
    drawLabel("Set Goal", 1075, 175, size=18, fill="black")



def draw_hours_meditated_screen(app):
    """Display hours meditated."""
    drawLabel(f"Total Hours Meditated: {hours_meditated:.1f}", WIDTH // 2, HEIGHT // 2, size=36, fill="black")
    
    # Back Button
    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")

'''https://stackoverflow.com/questions/20510768/count-frequency-of-words-in-a-list-and-sort-by-frequency'''
def calculate_word_frequency():
    """Calculate the most frequent words from journal feelings."""
    global word_frequency
    word_frequency.clear()
    for entry in journal_entries:
        for word in entry["feelings"].split():  # Split by spaces
            word = ''.join(c for c in word if c.isalnum())
            if word:
                word_frequency[word.lower()] = word_frequency.get(word.lower(), 0) + 1

# Journaling
journal_entries = []  # {date, mood, feelings}

'''https://www.youtube.com/watch?v=wNZSeWkp6J0'''
def add_journal_entry(mood, feelings):
    global journal_entries, MOOD_DATA
    current_date = time.strftime("%Y-%m-%d")
    entry = {"date": current_date, "mood": mood, "feelings": feelings}
    journal_entries.append(entry)
    if 1 <= mood <= 10:  # Ensure mood is within valid range
        MOOD_DATA.append(mood)


def view_journal_entries():
    """Display journal entries."""
    drawLabel("Journal Entries", WIDTH // 2, 100, size=36, fill="black")
    y_offset = 150
    for entry in journal_entries:
        date = entry["date"]
        mood = entry["mood"]
        feelings = entry["feelings"]
        drawLabel(f"{date}: Mood {mood}, Feelings: {feelings}", WIDTH // 2, y_offset, size=18, fill="darkblue")
        y_offset += 30
    # Back Button
    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")

'''https://www.geeksforgeeks.org/python-program-for-most-frequent-word-in-strings-list/'''
def draw_word_cloud_screen(app):
    """Display most frequent words."""
    drawLabel("Most Frequent Words", WIDTH // 2, 100, size=36, fill="black")
    calculate_word_frequency()
    sorted_words = sorted(word_frequency.items(), key=lambda x: -x[1])
    for i, (word, count) in enumerate(sorted_words[:10]):  # Top 10 words
        drawLabel(f"{word}: {count}", WIDTH // 2, 150 + i * 30, size=24, fill="darkgreen")
    
    # Back Button
    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")

def onAppStart(app):
    """Initialize the app."""
    app.current_screen = "menu"  # Default
    initialize_starfish_positions()
    app.inputs = {"mood": "", "feelings": "", "goal": ""}
    app.active_input = None
    app.current_affirmation = random.choice(affirmations)
    app.night_mode = False
    app.work_time = 0
    app.break_time = 0
    app.timer_active = False
    app.error_message = ""
    app.stepsPerSecond = 1  
    app.mode_label = "Day Mode" if app.night_mode else "Night Mode"
    app.daily_goal = 0  
    app.daily_goal_reached = False  
    app.current_month = "December"
    app.current_year = 2024
    app.steps = 0  

current_year = datetime.now().year
current_month = datetime.now().month

hours_meditated = 0.0

'''https://academy.cs.cmu.edu/notes/7149'''
def onStep(app):
    global meditation_timer, meditation_started
    update_waves()

    # Pomodoro Timer Logic
    if app.timer_active:
        if app.work_time > 0:
            app.work_time -= 1  
        elif app.break_time > 0:
            app.break_time -= 1  
        else:
            app.timer_active = False  

    # Meditation Timer
    if meditation_started and meditation_timer > 0:
        meditation_timer -= 1  # Decrement meditation timer
        if meditation_timer <= 0:  # Timer finished
            stop_meditation(app)

    #Daily Goal
    if app.daily_goal and hours_meditated >= app.daily_goal / 60:  # Convert goal to hours
        app.daily_goal_reached = True
        app.error_message = "Goal achieved! Great job!"

    app.steps += 1  # Increment app steps for synchronization

'''https://ultrapythonic.com/tkinter-entry/'''
def onKeyPress(app, key):
    if app.current_screen == "journal" and app.active_input in app.inputs:
        if key == "backspace":
            app.inputs[app.active_input] = app.inputs[app.active_input][:-1]
        elif len(key) == 1 and len(app.inputs[app.active_input]) < 50:  # Limit 50 characters
            app.inputs[app.active_input] += key

pomodoro_start_time = None

def onMousePress(app, mouseX, mouseY):
    print(f"Mouse pressed at: {mouseX}, {mouseY}")

    """Handle button clicks for navigation and actions."""
    global current_screen, current_meditation_duration, pomodoro_start_time
    global current_month, current_year
    if 50 < mouseX < 100 and 50 < mouseY < 100:  # Previous month
        current_month -= 1
        if current_month == 0:
            current_month = 12
            current_year -= 1
    elif WIDTH - 100 < mouseX < WIDTH - 50 and 50 < mouseY < 100:  # Next month
        current_month += 1
        if current_month == 13:
            current_month = 1
            current_year += 1

    # Check day clicks
    if 100 < mouseX < WIDTH - 100 and 200 < mouseY < 700:
        col = (mouseX - 100) // 100
        row = (mouseY - 200) // 100
        day = row * 7 + col - datetime(current_year, current_month, 1).weekday() + 1
        if 1 <= day <= days_in_month(current_month, current_year):
            show_entries_for_date(current_year, current_month, day)
    if app.current_screen == "pomodoro":
        if 400 < mouseX < 600 and 400 < mouseY < 450:  # Start Button
            app.work_time = 25 * 60  # 25 minutes
            app.break_time = 5 * 60  # 5 minutes
            app.timer_active = True
            app.pomodoro_start_time = time.time()
        elif 700 < mouseX < 900 and 400 < mouseY < 450:  # Stop Button
            app.timer_active = False
            app.pomodoro_start_time = None

    # Back Button 
    if 50 < mouseX < 200 and 50 < mouseY < 100:
        if app.current_screen != "menu":  
            app.current_screen = "menu"

    if app.current_screen == "menu":
        if 100 < mouseX < 300:
            if 150 < mouseY < 200:
                app.current_screen = "meditate"
            elif 225 < mouseY < 275:
                app.current_screen = "journal"
            elif 300 < mouseY < 350:
                app.current_screen = "mood_graph"
            elif 375 < mouseY < 425:
                app.current_screen = "hours_meditated"
            elif 450 < mouseY < 500:
                app.current_screen = "affirmations"
            elif 525 < mouseY < 575:
                app.current_screen = "word_cloud"
            elif 600 < mouseY < 650:
                app.current_screen = "calendar"
            elif 675 < mouseY < 725:  # Pomodoro Timer Button
                app.current_screen = "pomodoro"
            elif 1000 < mouseX < 1150 and 50 < mouseY < 100:  # Night Toggle Button
                toggle_night_mode(app)
            elif 1000 < mouseX < 1150 and 150 < mouseY < 200:  # Set Goal Button
                goal = app.inputs.get("goal", "").strip()
                if goal.isdigit() and int(goal) > 0:
                    app.daily_goal = int(goal)
                    app.daily_goal_reached = False
                    app.current_screen = "menu"
                    app.error_message = "Goal set successfully!"
                else:
                    app.error_message = "Invalid goal. Enter a positive number."



    elif app.current_screen == "meditate":
        if 400 < mouseX < 600:
            if 200 < mouseY < 250:
                start_meditation(app, 5) 
            elif 300 < mouseY < 350:
                start_meditation(app, 10)  
            elif 400 < mouseY < 450:
                start_meditation(app, 20)  
        elif 700 < mouseX < 900 and 500 < mouseY < 550:  # Stop button
            stop_meditation(app)  


    # Mood Graph Screen Logic
    elif app.current_screen == "mood_graph":
        if 50 < mouseX < 200 and 50 < mouseY < 100:  # Back button
            app.current_screen = "menu"

    # Hours Meditated Screen Logic
    elif app.current_screen == "hours_meditated":
        if 50 < mouseX < 200 and 50 < mouseY < 100:  # Back button
            app.current_screen = "menu"

    # Affirmations
    elif app.current_screen == "affirmations":
        if 400 < mouseX < 600 and 500 < mouseY < 550:  # Change Affirmation Button
            app.current_affirmation = random.choice(affirmations)
        elif 50 < mouseX < 200 and 50 < mouseY < 100:  # Back button
            app.current_screen = "menu"

    # Word Cloud 
    elif app.current_screen == "word_cloud":
        if 50 < mouseX < 200 and 50 < mouseY < 100:  # Back button
            app.current_screen = "menu"


    elif app.current_screen == "calendar":
        if 50 < mouseX < 100 and 50 < mouseY < 100:  # Previous month
            app.current_month = "November" if app.current_month == "December" else "December"
        elif WIDTH - 100 < mouseX < WIDTH - 50 and 50 < mouseY < 100:  # Next month
            app.current_month = "January" if app.current_month == "December" else "December"
        elif WIDTH // 2 - 100 < mouseX < WIDTH // 2 + 100 and HEIGHT - 100 < mouseY < HEIGHT - 50:  # Export
            export_calendar()


    elif app.current_screen == "pomodoro":
        if 400 < mouseX < 600 and 400 < mouseY < 450:  # Start
            app.work_time = 25 * 60
            app.break_time = 5 * 60
            app.timer_active = True
            pomodoro_start_time = time.time()
        elif 700 < mouseX < 900 and 400 < mouseY < 450:  # Stop
            app.timer_active = False
            pomodoro_start_time = None

    elif 1000 < mouseX < 1150 and 50 < mouseY < 100:
        app.night_mode = not app.night_mode

    elif app.current_screen == "journal":
        if 300 < mouseX < 900 and 200 < mouseY < 250:  # Mood Input Box
            app.active_input = "mood"
        elif 300 < mouseX < 900 and 300 < mouseY < 350:  # Feelings Input Box
            app.active_input = "feelings"
        elif 500 < mouseX < 700 and 400 < mouseY < 450:  # Save Button
            mood = app.inputs["mood"].strip()
            feelings = app.inputs["feelings"].strip()
            if mood.isdigit() and 1 <= int(mood) <= 10 and feelings:
                add_journal_entry(int(mood), feelings)
                app.inputs = {"mood": "", "feelings": ""}
                app.error_message = ""
            else:
                app.error_message = "Invalid input. Mood must be 1-10, and feelings cannot be empty."

    elif app.current_screen == "goal_setting":
        if 400 < mouseX < 800 and 200 < mouseY < 250:  # Goal input box
            app.active_input = "goal"
        elif 500 < mouseX < 700 and 300 < mouseY < 350:  # Set Goal button
            goal = app.inputs.get("goal", "").strip()
            if goal.isdigit() and int(goal) > 0:
                app.daily_goal = int(goal)
                app.daily_goal_reached = False
                app.error_message = "Goal set successfully!"
            else:
                app.error_message = "Invalid goal. Enter a positive number."


def draw_view_journal_screen():
    """Draw the screen to view journal entries."""
    drawLabel("Journal Entries", WIDTH // 2, 100, size=36, fill="black", bold=True)
    y = 150
    for entry in journal_entries:
        drawLabel(f"{entry['date']} - Mood: {entry['mood']} - {entry['feelings']}", WIDTH // 2, y, size=18, fill="black")
        y += 30
    # Back Button
    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")

def show_entries_for_date(year, month, day):
    date = f"{year}-{month:02}-{day:02}"
    entries = [entry for entry in journal_entries if entry["date"] == date]
    if entries:
        # Display entries for the specific date in the app
        print(f"Entries for {date}:")
        for entry in entries:
            print(f"  Mood: {entry['mood']}, Feelings: {entry['feelings']}")
    else:
        print(f"No entries for {date}.")

def days_in_month(month, year):
    """Return the number of days in a given month."""
    next_month = month % 12 + 1
    next_year = year + (1 if next_month == 1 else 0)
    return (datetime(next_year, next_month, 1) - timedelta(days=1)).day

def draw_meditation_screen(app):
    """Draw the meditation screen with durations and timer."""
    drawLabel("Select Meditation Duration", WIDTH // 2, 100, size=36, fill="black", bold=True)
    
    #  durations
    drawRect(400, 200, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("5 Minutes", 500, 225, size=24)
    
    drawRect(400, 300, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("10 Minutes", 500, 325, size=24)
    
    drawRect(400, 400, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("20 Minutes", 500, 425, size=24)
    
    # Start/Stop 
    drawRect(400, 500, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightgreen", border="black")
    drawLabel("Start", 500, 525, size=24)
    
    drawRect(700, 500, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightcoral", border="black")
    drawLabel("Stop", 800, 525, size=24)

    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")

    # Display Timer
    if meditation_started:
        minutes = meditation_timer // 60
        seconds = meditation_timer % 60
        drawLabel(f"Time Remaining: {minutes:02}:{seconds:02}", WIDTH // 2, 600, size=36, fill="darkblue")

'''https://realpython.com/python-calendar-module/'''
def draw_calendar_screen(app):
    global current_year, current_month

    drawLabel(f"{datetime(current_year, current_month, 1).strftime('%B %Y')}", WIDTH // 2, 50, size=36, fill="black")
    
    # Draw navigation buttons
    drawRect(50, 50, 50, 50, fill="lightgrey", border="black")  # Previous month
    drawLabel("<", 75, 75, size=24, fill="black")
    drawRect(WIDTH - 100, 50, 50, 50, fill="lightgrey", border="black")  # Next month
    drawLabel(">", WIDTH - 75, 75, size=24, fill="black")

    # Draw days of the week
    for i, day in enumerate(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]):
        drawLabel(day, 100 + i * 100, 150, size=18, fill="darkblue")

    # Draw days of the month
    first_day = datetime(current_year, current_month, 1).weekday()
    days = days_in_month(current_month, current_year)
    row, col = 0, first_day
    for day in range(1, days + 1):
        x, y = 100 + col * 100, 200 + row * 100
        drawRect(x, y, 80, 80, fill="lightblue", border="black")
        drawLabel(str(day), x + 40, y + 40, size=18, align="center")
        col += 1
        if col == 7:  # Move to next row after Saturday
            col = 0
            row += 1

def days_in_month(month, year):
    """Return the number of days in the given month."""
    next_month = month % 12 + 1
    next_year = year + (1 if next_month == 1 else 0)
    return (datetime(next_year, next_month, 1) - timedelta(days=1)).day


def redrawAll(app):
    """Handle the screen rendering based on the current screen."""
    draw_gradient_background(app)
    draw_waves()
    draw_beach()

    if app.current_screen == "menu":
        draw_menu(app)
    elif app.current_screen == "meditate":
        draw_meditation_screen(app)
    elif app.current_screen == "journal":
        draw_journal_screen(app)
    elif app.current_screen == "mood_graph":
        draw_mood_graph_screen(app)
    elif app.current_screen == "hours_meditated":
        draw_hours_meditated_screen(app)
    elif app.current_screen == "affirmations":
        draw_affirmation_screen(app)
    elif app.current_screen == "word_cloud":
        draw_word_cloud_screen(app)
    elif app.current_screen == "calendar":
        draw_calendar_screen(app)
    elif app.current_screen == "pomodoro":
        draw_pomodoro_screen(app)

def draw_affirmation_screen(app):
    """Draw the affirmations screen."""
    drawLabel("Affirmation:", WIDTH // 2, HEIGHT // 2 - 100, size=36, fill="black")
    drawLabel(app.current_affirmation, WIDTH // 2, HEIGHT // 2, size=24, fill="darkblue")
    
    # Affirmation Button
    drawRect(400, 500, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightblue", border="black")
    drawLabel("New Affirmation", 500, 525, size=24, fill="black")
    
    # Back Button
    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")

def toggle_night_mode(app):
    app.night_mode = not app.night_mode
    app.mode_label = "Day Mode" if app.night_mode else "Night Mode"


# Global Meditation
meditation_timer = 0
meditation_started = False
current_meditation_duration = 0
meditation_audio_url = None

'''https://academy.cs.cmu.edu/notes/7157'''

def start_meditation(app, duration):
    global meditation_timer, meditation_started, current_meditation_duration
    meditation_timer = duration * 60
    meditation_started = True
    current_meditation_duration = duration

    audio_urls = {
        5: "https://youtu.be/inpok4MKVLM",
        10: "https://youtu.be/ZToicYcHIOU",
        20: "https://youtu.be/2DXqMBXmP8Q",
    }
    if duration in audio_urls:
        webbrowser.open(audio_urls[duration])


def stop_meditation(app):
    global meditation_started, meditation_timer, hours_meditated
    if meditation_started:
        elapsed_time = (current_meditation_duration * 60 - meditation_timer) / 3600
        hours_meditated += elapsed_time
    meditation_started = False
    meditation_timer = 0
    if hasattr(app, 'meditation_audio'):
        app.meditation_audio.stop()


'''https://www.youtube.com/watch?v=7WEowpogweI'''
def draw_journal_screen(app):
    drawLabel("Journal Entry", WIDTH // 2, 100, size=36, fill="black", bold=True)
    drawRect(300, 200, 600, 50, fill="lightyellow", border="black")
    drawLabel("Enter Mood (1-10):", 310, 190, size=18, fill="darkblue")
    drawRect(300, 300, 600, 50, fill="lightyellow", border="black")
    drawLabel("How do you feel today?", 310, 290, size=18, fill="darkblue")
    drawRect(500, 400, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightgreen", border="black")
    drawLabel("Save Entry", 600, 425, size=24)

    mood_text = app.inputs["mood"].center(30)  # Center align
    feelings_text = app.inputs["feelings"].center(50)  # Center align
    drawLabel(mood_text, 310, 225, size=18, fill="black")
    drawLabel(feelings_text, 310, 325, size=18, fill="black")

    if app.error_message:
        drawLabel(app.error_message, WIDTH // 2, 500, size=20, fill="red")

    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24)

# Mood Tracking
mood_graph_data = []  # graph

'''https://www.geeksforgeeks.org/graph-plotting-in-python-set-1/'''
def draw_mood_graph_screen(app):
    drawLabel("Mood Tracker", WIDTH // 2, 50, size=36, fill="black")
    
    # Add Back Button
    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24, fill="black")
    
    if len(MOOD_DATA) > 1:
        avg_mood = sum(MOOD_DATA) / len(MOOD_DATA)
        drawLabel(f"Average Mood: {avg_mood:.2f}", WIDTH // 2, HEIGHT - 50, size=24, fill="black")
        
        drawLine(100, HEIGHT - 150, WIDTH - 100, HEIGHT - 150, fill="black")  # X-axis
        drawLine(100, 150, 100, HEIGHT - 150, fill="black")  # Y-axis

        for i, mood in enumerate(MOOD_DATA):
            x = 100 + i * 100
            y = HEIGHT - 150 - mood * 30
            drawCircle(x, y, 5, fill="blue")
            if i > 0:
                prev_x = 100 + (i - 1) * 100
                prev_y = HEIGHT - 150 - MOOD_DATA[i - 1] * 30
                drawLine(prev_x, prev_y, x, y, fill="blue")
    else:
        drawLabel("No data available yet.", WIDTH // 2, HEIGHT // 2, size=24, fill="red")



'''https://www.geeksforgeeks.org/export-pandas-dataframe-to-a-csv-file/'''
def export_calendar():
    with open("calendar_export.csv", "w") as f:
        f.write("Date,Mood,Feelings\n")
        for entry in journal_entries:
            f.write(f"{entry['date']},{entry['mood']},{entry['feelings']}\n")
    print("Calendar exported to calendar_export.csv")


def set_daily_goal(goal):
    app.daily_goal = goal
    app.daily_goal_reached = False

def check_daily_goal():
    if hours_meditated >= app.daily_goal / 60:
        app.daily_goal_reached = True
        drawLabel(f"Daily Goal of {app.daily_goal} Minutes Reached!", WIDTH // 2, HEIGHT // 2, size=36, fill="green")

# Goal Setting
def draw_goal_setting_screen(app):
    drawLabel("Set Daily Meditation Goal (minutes):", WIDTH // 2, 100, size=24, fill="black")
    drawRect(400, 200, 400, 50, fill="lightyellow", border="black")
    goal_text = app.inputs.get("goal", "")
    drawLabel(goal_text, 410, 225, size=24, fill="black")
    drawRect(500, 300, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightgreen", border="black")
    drawLabel("Set Goal", 600, 325, size=24)
    if app.error_message:
        drawLabel(app.error_message, WIDTH // 2, HEIGHT - 200, size=20, fill="red")


'''https://medium.com/@fidel.esquivelestay/build-a-pomodoro-timer-using-python-d52509730f60'''
def draw_pomodoro_screen(app):
    drawLabel("Pomodoro Timer", WIDTH // 2, 100, size=36, fill="black", bold=True)

    work_minutes = app.work_time // 60
    work_seconds = app.work_time % 60
    break_minutes = app.break_time // 60
    break_seconds = app.break_time % 60

    if app.timer_active:
        drawLabel(f"Work Time Remaining: {work_minutes:02}:{work_seconds:02}", WIDTH // 2, 200, size=24, fill="black")
        drawLabel(f"Break Time Remaining: {break_minutes:02}:{break_seconds:02}", WIDTH // 2, 300, size=24, fill="black")
    else:
        drawLabel("Pomodoro Timer Inactive", WIDTH // 2, 250, size=24, fill="red")

    drawRect(400, 400, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightgreen", border="black")
    drawLabel("Start", 500, 425, size=24)

    drawRect(700, 400, BUTTON_WIDTH, BUTTON_HEIGHT, fill="lightcoral", border="black")
    drawLabel("Stop", 800, 425, size=24)

    drawRect(50, 50, 150, 50, fill="lightgrey", border="black")
    drawLabel("Back", 125, 75, size=24)

runApp(width=WIDTH, height=HEIGHT)

