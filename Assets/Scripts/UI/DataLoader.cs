using UnityEngine;

namespace Assets.Scripts.UI
{
    public class DataLoader
    {
        private const string MessagesResourceName = "messages";
        private const string ToolsResourceName = "tools";
        private const string TutorialResourceName = "tutorial";


        public static Messages LoadMessageData()
        {
            return LoadData<Messages>(MessagesResourceName);
        }


        public static Tools LoadToolData()
        {
            return LoadData<Tools>(ToolsResourceName);
        }


        public static Tutorials LoadTutorialData()
        {
            return LoadData<Tutorials>(TutorialResourceName);
        }


        private static T LoadData<T>(string resourceName)
        {
            TextAsset file = Resources.Load(resourceName) as TextAsset;
            return Newtonsoft.Json.JsonConvert.DeserializeObject<T>(file.text);
        }
    }
}
