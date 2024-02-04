class Player:
    def __init__(self, name):
        """
        Initialisation d'un joueur
        """
        self.name = name
        self.health = 100
        self.luck = 0
        self.defense = 0
        self.purse = 10

    def attack(self, target):
        print(f"{self.name} attaque {target}!")

    def take_damage(self, damage):
        self.health -= damage
        if self.health <= 0:
            print(f"{self.name} a été vaincu!")

    def heal(self, amount):
        self.health += amount
        print(f"{self.name} a été soigné de {amount} points de vie.")

    def __str__(self):
        return f"{self.name} - Niveau {self.level}"