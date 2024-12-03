CREATE TABLE IF NOT EXISTS `wais_leaderboardv2` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(255) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `profile` JSON NOT NULL,
    `kills` INT DEFAULT 0,
    `deaths` INT DEFAULT 0,
    `create` INT NOT NULL,
    UNIQUE (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
