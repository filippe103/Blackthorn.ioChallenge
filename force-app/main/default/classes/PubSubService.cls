/**
 * @description A simple Pub/Sub pattern implementation
 */
public with sharing class PubSubService {
    Set<IHandleMessages> subscribers;
    
    private PubSubService() {
        subscribers = new Set<IHandleMessages>();
    }

    /**
     * @description A singleton for service interaction.
     */
    public static PubSubService Instance {
        get {
            if (Instance == null) {
                Instance = new PubSubService();
            }

            return Instance;
        }

        private set;
    }

    /**
     * @description Subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void subscribe(IHandleMessages implementation) {
        ArgumentNullException.throwIfNull(implementation, 'implementation');
        if (!subscribers.contains(implementation)) {
            subscribers.add(implementation);
        }
    }

    /**
     * @description Un-subscribes a given IHandleMessages implementation to the channels it returns.
     * @param implementation An instance of IHandleMessages.
     * @throws ArgumentNullException if implementation is null.
     */
    public void unsubscribe(IHandleMessages implementation) {
        ArgumentNullException.throwIfNull(implementation, 'implementation');
        if (subscribers.contains(implementation)) {
            subscribers.remove(implementation);
        }
    }

    /**
     * @description Emits a message to a given channel containing the specified data.
     * @param channel The channel to emit a message on.
     * @param data The data to emit.
     * @throws ArgumentNullException if channel is null.
     */
    public void emit(String channel, Object data) {
        for (IHandleMessages subscriber : subscribers) {
            if (subscriber.getSubscribedChannels().contains(channel)) {
                subscriber.handleMessage(channel, data);
            }
        }
    }
}