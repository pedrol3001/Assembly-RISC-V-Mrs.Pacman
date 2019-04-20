using System;
using System.Collections.Generic;
using System.IO;

///////////////////////////////////////////////////////
//
//      MidiExtractor -- by Karn Bianco
//
// Reads Midi files exported to text files and converts 
// the data to a custom (.karn) binary format.
//
///////////////////////////////////////////////////////

namespace MidiExtractor
{
    class MidiExtractor
    {
        private List<string> MidiText;   // Midi text file lines
        private List<UInt16> Durations;  // Note durations        
        private List<UInt16> Pauses;     // Pause before next note
        private List<byte> Pitches;      // Note pitches
        private List<byte> Channels;     // Note channels
        private List<byte> Velocities;   // Note velocities
        private int TempoChanges = 0;    // Number of tempo changes

        // Look up table for each channel and its instrument
        private Dictionary<byte, byte> InstrumentChannels;       

        public MidiExtractor()
        {
            // Get names of all files in MidiText directory
            string[] fileEntries = Directory.GetFiles("MidiText");

            // Loop through all MidiText files
            foreach (string fileName in fileEntries)
            {
                Initialize();               // Initialize/reset all variables
                ReadMidiText(fileName);     // Read the midi text, save the contents
                GetChannelInstruments();    // Get channel and instrument data
                GetNoteData();              // Calculate notes, duration, start times
                WriteToBinary(fileName);    // Write data out to a custom binary format
            }

            // Write names of all converted files to a text document
            using (StreamWriter w = new StreamWriter("KarnFiles.txt"))
            {
                foreach (string fileName in fileEntries)
                {
                    string stripped = fileName.Remove(0, 9);              // Remove directory
                    stripped = stripped.Remove(stripped.Length - 4, 4);   // Remove extension
                    stripped = stripped + ".karn";                        // Add new extension
                    w.WriteLine(stripped);
                }
            }
        }

        private void Initialize()
        {
            MidiText = new List<string>();      // Midi file lines
            Durations = new List<UInt16>();     // Note durations
            Pauses = new List<UInt16>();        // Pause before next note
            Pitches = new List<byte>();         // Notes            
            Channels = new List<byte>();        // Note channels
            Velocities = new List<byte>();      // Note velocities/volumes

            InstrumentChannels = new Dictionary<byte, byte>();    // Channels used and instruments
        }

        private void ReadMidiText(string fileName)
        {
            // Create a StreamReader and open the file
            StreamReader reader = new StreamReader(fileName);

            // Read midi output file
            while (!reader.EndOfStream)
            {
                MidiText.Add(reader.ReadLine());
            }

            reader.Close();     // Close the file/stream

            // Calculate data offset (number of tempo changes)
            string[] SongCounts = MidiText[8].Split('|');
            TempoChanges = int.Parse(SongCounts[2]); 
        }

        private void WriteToBinary(string fileName)
        {
            string newFileName = fileName.Remove(fileName.Length - 4, 4);   // Remove extension
            newFileName = newFileName.Remove(0, 9);                         // Remove directory
            newFileName = newFileName.Insert(0, "BinaryOutput\\");          // Add new directory
            newFileName = newFileName + ".karn";                            // Add new extension

            // Open and write to new binary file, or overwrite existin
            using (BinaryWriter b = new BinaryWriter(File.Open(newFileName, FileMode.Create)))
            {
                // Write number of channels used
                b.Write(byte.Parse(InstrumentChannels.Count.ToString()));

                // Write number of notes in two bytes
                b.Write((UInt16)(Pitches.Count));

                // Write Channel Information
                for (byte i = 0; i < 16; i++)
                {
                    if (InstrumentChannels.ContainsKey(i))
                    {
                        b.Write(i);                         // Write channel number
                        b.Write(InstrumentChannels[i]);     // Write instrument
                    }                    
                }

                // Write out each notes and its start, pitch, duration, channel, velocity
                for (int i = 0; i < Pitches.Count; i++)
                {     
                    b.Write((byte)Pitches[i]);
                    b.Write((UInt16)Durations[i]);
                    b.Write((byte)Channels[i]);
                    b.Write((byte)Velocities[i]);
                    b.Write((UInt16)Pauses[i]); 
                }
            }
        }

        private void GetChannelInstruments()
        {
            string ChannelInstrumentsText = MidiText[9 + TempoChanges]; 

            // Instrument data ordered by 0-based channel
            string[] Instruments = ChannelInstrumentsText.Split('|');

            // Retrieve channel and instrument info
            for (byte i = 0; i < 16; i++)
            {
                // Channel contains instrument
                if (Instruments[i] != "-1")
                {
                    InstrumentChannels.Add(i, byte.Parse(Instruments[i]));
                }
            }
        }

        private void GetNoteData()
        {
            // Start at first line of note data and loop through
            for (int i = (11 + TempoChanges); i < MidiText.Count; i++)
            {
                // Get this note's data in string form
                string[] NoteData = MidiText[i].Split('|');

                // Calculate Pause times
                if (i < MidiText.Count - 1)
                {
                    // Get the next note's data
                    string[] NextNoteData = MidiText[i + 1].Split('|');

                    // Calculate time between this note and the next
                    int Start = int.Parse(NoteData[0]);
                    int NextStart = int.Parse(NextNoteData[0]);
                    Pauses.Add((UInt16)(NextStart - Start));
                }
                else
                {
                    Pauses.Add((UInt16)0);  // Final pause
                }

                Channels.Add(byte.Parse(NoteData[1]));
                Pitches.Add(byte.Parse(NoteData[2]));
                Velocities.Add(byte.Parse(NoteData[3]));

                try   { Durations.Add(UInt16.Parse(NoteData[4])); }
                catch (Exception) { Durations.Add((UInt16)(500)); }
            }
        }
    }
}