import { Context } from "./Context";
import { useContext, useEffect, useMemo } from "react";

import { IoImage } from "react-icons/io5";

const OwnProfile = () => {
    const { Lang, Ranks, setEditableModal, currentProfile } = useContext(Context);
    const modalKDA = useMemo(() => {
        return isNaN(currentProfile.kills / currentProfile.deaths) ? 0.0 : (currentProfile.kills / currentProfile.deaths).toFixed(1);
    }, [currentProfile.kills, currentProfile.deaths]);

    const getRank = useMemo(() => {
        let latestRank = null;
        for (const key in Ranks) {
            const kda = modalKDA;
    
            if (kda >= Ranks[key].kda) {
                latestRank = key;
            }
        }

        return { 
            rank: latestRank,
            color: Ranks[latestRank].color,
        };
    }, [currentProfile.kills, currentProfile.deaths]);

    return  (
        <div className="profile-side">
            <div className="profile">
                <IoImage id="profile-image" onClick={() => setEditableModal(true)} />
                <div className="player-profile-things">
                    <div className="profile-picture">
                        <img src={currentProfile.profile.avatar} />
                    </div>
                    <div className="player-thing">
                        <div className="player-name">
                            <span>{currentProfile.name}</span>
                        </div>
                        <div className="player-message">
                            <span>{currentProfile.profile.status}</span>
                        </div>
                    </div>
                </div>
                <img src={currentProfile.profile.banner} id="wallpaper" />
            </div>

            <div className="player-stats">
                <div className="stat-wrapper">
                    <div className="stats">
                        <img src="../../public/images/shuriken.png" id="stat-icon" />
                        <img src="../../public/images/shuriken.png" id="stat-big-icon" />
                        <div className="stats-name">
                            <span>{Lang.kills}</span>
                        </div>
                        <span>{currentProfile.kills}</span>
                        <div className="stats-shadow"></div>
                    </div>

                    <div className="stats">
                        <img src="../../public/images/skull.png" id="stat-icon" />
                        <img src="../../public/images/skull.png" id="stat-big-icon" />
                        <div className="stats-name">
                            <span>{Lang.deaths}</span>
                        </div>
                        <span>{currentProfile.deaths}</span>
                        <div className="stats-shadow"></div>
                    </div>
                </div>

                <div className="stat-wrapper">
                    <div className="stats">
                        <img src="../../public/images/m4a1.png" id="stat-icon" />
                        <img src="../../public/images/m4a1.png" id="stat-big-icon" />
                        <div className="stats-name">
                            <span>{Lang.kda}</span>
                        </div>
                        <span>{modalKDA}</span>
                        <div className="stats-shadow"></div>
                    </div>
                </div>

                <div className="stat-wrapper">
                    <div className="stats">
                        <img src="../../public/images/crown.png" id="stat-icon" />
                        <img src="../../public/images/crown.png" id="stat-big-icon" style={{
                            rotate: "180deg",
                            top: "-5vh",
                        }} />
                        <div className="stats-name">
                            <span>{Lang.rank}</span>
                        </div>
                        <span style={{color: getRank.color}}>{getRank.rank}</span>
                        <div className="stats-shadow"></div>
                    </div>

                    <div className="stats">
                        <img src={`https://flagsapi.com/${currentProfile.profile.country}/shiny/64.png`} id="country-icon" />
                        <div className="stats-name">
                            <span>{Lang.country}</span>
                        </div>
                        <span>{currentProfile.profile.country}</span>
                        <div className="stats-shadow"></div>
                    </div>
                </div>

                <div className="stat-wrapper">
                    <div className="stats">
                        <div className="stats-name">
                            <span>{Lang.first_login}</span>
                        </div>
                        <span>
                            {
                                new Date(currentProfile.create).toLocaleDateString(`${currentProfile.profile.country.toLowerCase()}-${currentProfile.profile.country.toUpperCase()}`, {
                                    year: 'numeric', month: 'numeric', day: 'numeric'
                                })
                            }
                        </span>
                        <div className="stats-shadow"></div>
                    </div>

                    <div className="stats">
                        <div className="stats-name">
                            <span>{Lang.last_login}</span>
                        </div>
                        <span>{Lang.today}</span>
                        <div className="stats-shadow"></div>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default OwnProfile;