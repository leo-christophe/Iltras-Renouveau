class Story:
    def __init__(self, title, chapters):
        self.title = title
        self.chapters = chapters

    def next_chapter(self):
        self.chapters+=1
        print("Chapitre suivant")