import { useState, useEffect, createContext } from "react";
const getConfig = await fetchData().then(data => { return data });
async function fetchData() { try { const response = await fetch('../../../public/Config.json', { headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' } }); const data = await response.json(); return data; } catch (error) { console.error('Error receiving data. Make sure the json files in the public file. [Config.json]', error); throw error; } }
await new Promise(resolve => setTimeout(resolve, 250));

const Context = createContext();
const ContextProvider = ({ children }) => {
    const Lang = getConfig.languages;
    const Ranks = getConfig.ranks;

    const [currentProfile, setCurrentProfile] = useState({
        name: "John Doe",
        profile: {
            banner: "https://images.pexels.com/photos/36487/above-adventure-aerial-air.jpg?cs=srgb&dl=pexels-bess-hamiti-83687-36487.jpg&fm=jpg",
            avatar: "https://i.pinimg.com/474x/5c/be/a6/5cbea638934c3a0181790c16a7832179.jpg",
            status: "Sponsored by: John Doe",
            country: "TR",
        },

        kills: 0,
        deaths: 0,
        create: "2024.10.3",
    });

    const [otherProfile, setOtherProfile] = useState({
        show: false,
        name: null,
        profile: {
            banner: null,
            avatar: null,
            status: null,
            country: null,
        },

        kills: null,
        deaths: null,
    });
    const [editableModal, setEditableModal] = useState(false);
    const [boardData, setBoardData] = useState({});

    const closeOtherProfile = () => {
        setOtherProfile((prev) => {
            return {
                ...prev,
                show: false,
            }
        })
    }

    const changeBoardData = (data) => {
        setBoardData(data);
    }

    const addBoardRow = (hex, data) => {
        setBoardData((prev) => {
            const newBoard = { ...prev }
            newBoard[hex] = data
            return newBoard
        })
    }

    const addKillBoardPlayer = (hex) => {
        setBoardData((prev) => {
            const newBoard = { ...prev }
            newBoard[hex].kills += 1
            return newBoard
        })
    }

    const addDeathBoardPlayer = (hex) => {
        setBoardData((prev) => {
            const newBoard = { ...prev }
            newBoard[hex].deaths += 1
            return newBoard
        })
    }

    const updateBoardPlayerProfile = (hex, statusMessage, bannerUrl) => {
        setBoardData((prev) => {
            const newBoard = { ...prev }
            newBoard[hex].profile.banner = bannerUrl
            newBoard[hex].profile.status = statusMessage
            return newBoard
        })
    }

    const updateProfile = (statusMessage, bannerUrl) => {
        setCurrentProfile((prev) => {
            return {
                ...prev,
                profile: {
                    ...prev.profile,
                    banner: bannerUrl,
                    status: statusMessage,
                }
            }
        })
    }

    return (
        <Context.Provider value={{ 
            Lang, Ranks,

            currentProfile, setCurrentProfile,
            otherProfile, setOtherProfile,
            editableModal, setEditableModal,
            boardData, setBoardData,

            closeOtherProfile, changeBoardData,
            addKillBoardPlayer, addDeathBoardPlayer, updateBoardPlayerProfile, updateProfile, addBoardRow
        }}>
            {children}
        </Context.Provider>
    )
}

export { ContextProvider, Context }