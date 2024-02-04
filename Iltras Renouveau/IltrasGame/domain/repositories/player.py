class PlayerRepository:
    def __init__(self):
        self.players = []

    def add_player(self, player):
        self.players.append(player)

    def get_player_by_id(self, id):
        for player in self.players:
            if player.id == id:
                return player
        return None

    def update_player(self, id, name, age):
        player = self.get_player_by_id(id)
        if player:
            player.name = name
            player.age = age
            return True
        return False

    def delete_player(self, id):
        player = self.get_player_by_id(id)
        if player:
            self.players.remove(player)
            return True
        return False