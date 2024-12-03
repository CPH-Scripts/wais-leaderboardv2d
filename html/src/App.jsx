import { useState, useEffect, useContext } from 'react'
import { Context } from './components/Context'
import Emit from './components/Emit'

import OtherProfile from './components/OtherProfile'
import Header from './components/Header'
import Container from './components/Container'
import VisualElements from './components/VisualElements'
import Modal from './components/Modal'
import '../public/css/style.css'

const App = () => {
  const { otherProfile, editableModal, setCurrentProfile, setOtherProfile, changeBoardData, addKillBoardPlayer, addDeathBoardPlayer, updateBoardPlayerProfile, updateProfile, addBoardRow } = useContext(Context)
  const [showUI, setShowUI] = useState(false)

  useEffect(() => {
    const mHandler = e => {
      const type = e.data.type
      switch (type) {
        case 'SET_DATA':
          setCurrentProfile(e.data.player);
          changeBoardData(e.data.board);
          break;
        case "OPEN_UI":
          window.focus()
          setShowUI(true)
          break;
        case "HIDE_UI":
          setShowUI(false)
          break;
        case "UPDATE_KILL":
          setCurrentProfile((prev) => {
            return {
              ...prev,
              kills: prev.kills + 1,
            }
          })
          break;
        case "UPDATE_DEATH":
          setCurrentProfile((prev) => {
            return {
              ...prev,
              deaths: prev.deaths + 1,
            }
          })
          break;
        case "UPDATE_BOARD_KILL":
          addKillBoardPlayer(e.data.hex)
          break;
        case "UPDATE_BOARD_DEATH":
          addDeathBoardPlayer(e.data.hex)
          break;
        case "UPDATE_BOARD":
          changeBoardData(e.data.board)
          break;
        case "UPDATE_BOARD_PROFILE":
          updateBoardPlayerProfile(e.data.hex, e.data.data.status, e.data.data.banner)
          break;
        case "UPDATE_PROFILE":
          updateProfile(e.data.data.status, e.data.data.banner)
          break;
        case "ADD_BOARD_ROW":
          addBoardRow(e.data.hex, e.data.data)
          break;
        default: break;
      }
    }

    const keyDown = e => {
      const key = e.key
      if (key == "Escape") {
        if (otherProfile.show) {return setOtherProfile((prev) => {return {...prev,show: false}})}
        Emit('close', {}, () => {}) 
      }
    }

    window.addEventListener('message', mHandler)
    window.addEventListener('keydown', keyDown)
    return () => {
      window.removeEventListener('message', mHandler)
      window.removeEventListener('keydown', keyDown)
    }
  }, [otherProfile])

  useEffect(() => {
    Emit('ready', {}, () => {});
  }, [])

  return (
    showUI &&
    <>
      <VisualElements />
      {editableModal && <Modal />}
      {otherProfile.show && <OtherProfile />}
      <div className="app">
        <Header />
        <Container />
      </div>
    </>
  )
}

export default App
